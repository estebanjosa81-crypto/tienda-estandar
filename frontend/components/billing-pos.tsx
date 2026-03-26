'use client'

import { useState, useEffect, useRef } from 'react'
import { useStore, calculateCartTotals } from '@/lib/store'
import { api } from '@/lib/api'
import { TAX_RATE, type PaymentMethod, type CustomerFull, type Sale } from '@/lib/types'
import { formatCOP } from '@/lib/utils'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'
import { Search, Plus, X, Printer, FileText, Settings2, Trash2, Pencil } from 'lucide-react'
import { toast } from 'sonner'

interface BillingPOSProps {
  onToggleMode: () => void
}

export function BillingPOS({ onToggleMode }: BillingPOSProps) {
  const {
    products, fetchProducts,
    cart, addToCart, removeFromCart, updateCartQuantity, clearCart,
    addSale, cancelSale, storeInfo,
    selectedCustomer, setSelectedCustomer,
    categories,
  } = useStore()

  const hiddenCategoryIds = new Set(categories.filter(c => c.isHidden).map(c => c.id))

  // Invoice form
  const [paymentMethodLabel, setPaymentMethodLabel] = useState('EFECTIVO')
  const [paymentMethod, setPaymentMethod] = useState<PaymentMethod>('efectivo')
  const [formaPago, setFormaPago] = useState<'contado' | 'credito'>('contado')
  const [remision, setRemision] = useState(false)
  const [applyIva, setApplyIva] = useState(false)
  const [amountPaid, setAmountPaid] = useState('')

  // Customer
  const [customerSearch, setCustomerSearch] = useState('')
  const [customerResults, setCustomerResults] = useState<CustomerFull[]>([])
  const [isSearchingCustomers, setIsSearchingCustomers] = useState(false)
  const [showCustomerDropdown, setShowCustomerDropdown] = useState(false)

  // Product search
  const [productSearch, setProductSearch] = useState('')
  const [productQty, setProductQty] = useState(1)
  const [productPrice, setProductPrice] = useState(0)
  const [showProductDropdown, setShowProductDropdown] = useState(false)

  // Per-item price overrides (productId -> unit price)
  const [itemPrices, setItemPrices] = useState<Record<string, number>>({})

  // Sale state
  const [isProcessing, setIsProcessing] = useState(false)
  const [completedSale, setCompletedSale] = useState<Sale | null>(null)

  // Refs
  const productSearchRef = useRef<HTMLInputElement>(null)
  const cashInputRef = useRef<HTMLInputElement>(null)
  const customerDropdownRef = useRef<HTMLDivElement>(null)

  // Totals (use itemPrices overrides)
  const subtotal = cart.reduce((sum, item) => {
    const price = itemPrices[item.product.id] ?? item.product.salePrice
    return sum + price * item.quantity * (1 - item.discount / 100)
  }, 0)
  const tax = applyIva ? subtotal * TAX_RATE : 0
  const total = subtotal + tax
  const change = Math.max(0, parseFloat(amountPaid || '0') - total)

  const todayStr = new Date().toLocaleDateString('es-CO', {
    day: '2-digit', month: '2-digit', year: 'numeric',
  })

  useEffect(() => {
    fetchProducts()
  }, [fetchProducts])

  // Filtered products for search dropdown (exclude insumos and hidden categories)
  const filteredProducts = products.filter(p => {
    if (p.category === 'insumos') return false
    if (hiddenCategoryIds.has(p.category)) return false
    if (!productSearch.trim()) return false
    const q = productSearch.toLowerCase()
    return (
      p.name.toLowerCase().includes(q) ||
      p.sku.toLowerCase().includes(q) ||
      (p.articulo && p.articulo.toLowerCase().includes(q)) ||
      (p.barcode && p.barcode.toLowerCase().includes(q))
    )
  }).slice(0, 12)

  // Keyboard shortcuts
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'F4') {
        e.preventDefault()
        productSearchRef.current?.focus()
        productSearchRef.current?.select()
      }
      if (e.key === 'F11') {
        e.preventDefault()
        cashInputRef.current?.focus()
        cashInputRef.current?.select()
      }
      if (e.key === 'F12') {
        e.preventDefault()
        if (completedSale) handlePrint(completedSale)
        else if (cart.length > 0) handleCompleteSale()
      }
      if (e.key === 'F3') {
        e.preventDefault()
        handleNewInvoice()
      }
    }
    window.addEventListener('keydown', handleKeyDown)
    return () => window.removeEventListener('keydown', handleKeyDown)
  }, [completedSale, cart.length])

  // Close customer dropdown on outside click
  useEffect(() => {
    const handleClick = (e: MouseEvent) => {
      if (customerDropdownRef.current && !customerDropdownRef.current.contains(e.target as Node)) {
        setShowCustomerDropdown(false)
      }
    }
    document.addEventListener('mousedown', handleClick)
    return () => document.removeEventListener('mousedown', handleClick)
  }, [])

  // Customer search handler
  const handleCustomerSearch = async (query: string) => {
    setCustomerSearch(query)
    if (query.length < 2) {
      setCustomerResults([])
      setShowCustomerDropdown(false)
      return
    }
    setIsSearchingCustomers(true)
    const result = await api.searchCustomers(query)
    if (result.success && result.data) {
      setCustomerResults(result.data)
      setShowCustomerDropdown(true)
    }
    setIsSearchingCustomers(false)
  }

  const handleSelectCustomer = (cust: CustomerFull) => {
    setSelectedCustomer(cust)
    setCustomerSearch(`${cust.name} - (${cust.id.slice(0, 4)})`)
    setShowCustomerDropdown(false)
    setCustomerResults([])
  }

  const handleClearCustomer = () => {
    setSelectedCustomer(null)
    setCustomerSearch('')
  }

  // Add product to cart from search
  const handleAddProductFromSearch = (productId: string) => {
    const product = products.find(p => p.id === productId)
    if (!product) return
    const qty = productQty > 0 ? productQty : 1
    for (let i = 0; i < qty; i++) addToCart(product)
    if (productPrice > 0 && productPrice !== product.salePrice) {
      // custom price would need custom amount logic
    }
    setProductSearch('')
    setShowProductDropdown(false)
    setProductQty(1)
    setProductPrice(0)
    productSearchRef.current?.focus()
  }

  const handleProductSearchKey = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') {
      if (filteredProducts.length === 1) {
        handleAddProductFromSearch(filteredProducts[0].id)
      }
    }
    if (e.key === 'Escape') {
      setShowProductDropdown(false)
      setProductSearch('')
    }
  }

  const handleCompleteSale = async () => {
    if (cart.length === 0) {
      toast.error('Agrega al menos un producto a la factura')
      return
    }
    setIsProcessing(true)
    const saleItems = cart.map(item => {
      const overridePrice = itemPrices[item.product.id]
      const baseDiscount = item.discount
      // If price was overridden downward, encode as discount %
      let discount = baseDiscount
      if (overridePrice !== undefined && overridePrice < item.product.salePrice && item.product.salePrice > 0) {
        discount = Math.round((1 - overridePrice / item.product.salePrice) * 100)
      }
      return {
        productId: item.product.id,
        quantity: item.quantity,
        discount,
        ...(item.customAmount ? { customAmount: item.customAmount } : {}),
      }
    })

    const effectivePaymentMethod: PaymentMethod = formaPago === 'credito' ? 'fiado' : paymentMethod
    const effectiveAmountPaid = formaPago === 'credito' ? 0 : (parseFloat(amountPaid) || total)

    const result = await addSale({
      items: saleItems,
      paymentMethod: effectivePaymentMethod,
      amountPaid: effectiveAmountPaid,
      customerId: selectedCustomer?.id,
      customerName: selectedCustomer?.name,
      customerPhone: selectedCustomer?.phone,
      applyTax: applyIva,
    })

    setIsProcessing(false)

    if (result.success && result.data) {
      setCompletedSale(result.data)
      toast.success(`✓ Factura ${result.data.invoiceNumber} guardada`)
      handlePrint(result.data)
    } else {
      toast.error(result.error || 'Error al guardar la factura')
    }
  }

  const handleNewInvoice = () => {
    clearCart()
    setSelectedCustomer(null)
    setCustomerSearch('')
    setAmountPaid('')
    setCompletedSale(null)
    setFormaPago('contado')
    setRemision(false)
    setPaymentMethod('efectivo')
    setPaymentMethodLabel('EFECTIVO')
    setProductSearch('')
    setProductQty(1)
    setProductPrice(0)
    setItemPrices({})
    setTimeout(() => productSearchRef.current?.focus(), 50)
  }

  const handleAnular = async () => {
    if (!completedSale) {
      toast.error('No hay factura guardada para anular')
      return
    }
    const result = await cancelSale(completedSale.id, 'Anulación desde facturación')
    if (result.success) {
      toast.success('Factura anulada')
      handleNewInvoice()
    } else {
      toast.error(result.error || 'Error al anular')
    }
  }

  const handlePrint = (sale: Sale) => {
    const printWindow = window.open('', '_blank')
    if (!printWindow) return

    const copies = storeInfo.invoiceCopies ?? 1
    const paymentLabels: Record<string, string> = {
      efectivo: 'Efectivo', tarjeta: 'Tarjeta', transferencia: 'Transferencia',
      fiado: 'Crédito', addi: 'Addi', sistecredito: 'Sistecredito', mixto: 'Mixto',
    }

    const invoiceHtml = `
      <div class="invoice">
        <div class="header">
          ${storeInfo.invoiceLogo ? `<img src="${storeInfo.invoiceLogo}" alt="Logo" style="max-height:70px;max-width:200px;object-fit:contain;margin-bottom:8px;" />` : ''}
          <h1>${storeInfo.name}</h1>
          <p class="nit">NIT: ${storeInfo.taxId}</p>
          <p>${storeInfo.address}</p>
          <p>Tel: ${storeInfo.phone} | ${storeInfo.email}</p>
        </div>
        <div class="invoice-info">
          <div>
            <h3>Factura de Venta${remision ? ' / Remisión' : ''}</h3>
            <p><strong>No: ${sale.invoiceNumber}</strong></p>
            <p>Fecha: ${new Date(sale.createdAt).toLocaleDateString('es-CO', { year: 'numeric', month: 'long', day: 'numeric' })}</p>
            <p>Hora: ${new Date(sale.createdAt).toLocaleTimeString('es-CO')}</p>
            <p>Forma de pago: ${formaPago === 'credito' ? 'Crédito' : 'Contado'}</p>
          </div>
          <div>
            <h3>Cliente</h3>
            ${sale.customerName ? `<p>${sale.customerName}</p>` : '<p>Consumidor Final</p>'}
            ${sale.customerPhone ? `<p>Tel: ${sale.customerPhone}</p>` : ''}
            ${selectedCustomer?.cedula ? `<p>CC: ${selectedCustomer.cedula}</p>` : ''}
            ${sale.sellerName ? `<p style="margin-top:10px"><strong>Vendedor:</strong> ${sale.sellerName}</p>` : ''}
          </div>
        </div>
        <table>
          <thead>
            <tr>
              <th>#</th>
              <th>Código</th>
              <th>Descripción</th>
              <th>Cant.</th>
              <th class="text-right">IVA</th>
              <th class="text-right">V. Unitario</th>
              <th class="text-right">Subtotal</th>
              <th class="text-right">Total</th>
            </tr>
          </thead>
          <tbody>
            ${sale.items.map((item, idx) => {
              const itemSubtotal = item.subtotal ?? item.total ?? 0
              const itemIva = applyIva ? itemSubtotal * TAX_RATE : 0
              const itemTotal = itemSubtotal + itemIva
              return `
                <tr>
                  <td>${idx + 1}</td>
                  <td>${item.sku || item.productSku || '-'}</td>
                  <td>${item.productName}</td>
                  <td>${item.quantity}</td>
                  <td class="text-right">$${itemIva.toLocaleString('es-CO')}</td>
                  <td class="text-right">$${item.unitPrice.toLocaleString('es-CO')}</td>
                  <td class="text-right">$${itemSubtotal.toLocaleString('es-CO')}</td>
                  <td class="text-right">$${itemTotal.toLocaleString('es-CO')}</td>
                </tr>`
            }).join('')}
          </tbody>
        </table>
        <table class="totals">
          <tr><td>Subtotal:</td><td class="text-right">$${sale.subtotal.toLocaleString('es-CO')}</td></tr>
          ${sale.discount > 0 ? `<tr><td>Descuento:</td><td class="text-right">-$${sale.discount.toLocaleString('es-CO')}</td></tr>` : ''}
          ${sale.tax > 0
            ? `<tr><td style="color:#b45309;font-weight:600">IVA (19%):</td><td class="text-right" style="color:#b45309;font-weight:600">$${sale.tax.toLocaleString('es-CO')}</td></tr>`
            : `<tr><td style="color:#16a34a">Sin IVA:</td><td class="text-right" style="color:#16a34a">$0</td></tr>`}
          <tr class="total-row"><td>TOTAL:</td><td class="text-right">$${sale.total.toLocaleString('es-CO')}</td></tr>
        </table>
        <div class="payment-info">
          <h3>Pago</h3>
          <p><strong>Método:</strong> ${paymentLabels[sale.paymentMethod] || sale.paymentMethod}</p>
          <p><strong>Forma:</strong> ${formaPago === 'credito' ? 'Crédito' : 'Contado'}</p>
          ${sale.amountPaid > 0 ? `<p><strong>Recibido:</strong> $${sale.amountPaid.toLocaleString('es-CO')}</p>` : ''}
          ${sale.change > 0 ? `<p><strong>Cambio:</strong> $${sale.change.toLocaleString('es-CO')}</p>` : ''}
        </div>
        <div class="footer">
          <p><strong>${storeInfo.invoiceGreeting || '¡Gracias por su compra!'}</strong></p>
          ${(storeInfo.invoicePolicy || '').split('\n').map(line => `<p>${line}</p>`).join('')}
          <p>${storeInfo.name} - ${storeInfo.phone}</p>
        </div>
      </div>`

    printWindow.document.write(`
      <html>
        <head>
          <title>Factura ${sale.invoiceNumber}</title>
          <style>
            body { font-family: Arial, sans-serif; padding: 30px; max-width: 800px; margin: 0 auto; color: #333; font-size: 14px; }
            .invoice { margin-bottom: 0; }
            .page-break { border: none; border-top: 2px dashed #aaa; margin: 30px 0; page-break-after: always; }
            .header { text-align: center; border-bottom: 2px solid #333; padding-bottom: 15px; margin-bottom: 20px; }
            .header h1 { margin: 0 0 5px 0; font-size: 22px; }
            .header p { margin: 3px 0; color: #555; font-size: 13px; }
            .header .nit { font-weight: bold; font-size: 14px; }
            .invoice-info { display: flex; justify-content: space-between; margin-bottom: 20px; }
            .invoice-info h3 { margin: 0 0 8px 0; font-size: 13px; color: #666; text-transform: uppercase; }
            .invoice-info p { margin: 3px 0; font-size: 13px; }
            table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
            th { background: #f0f0f0; padding: 8px 6px; text-align: left; border-bottom: 2px solid #ccc; font-size: 11px; text-transform: uppercase; }
            td { padding: 6px; border-bottom: 1px solid #eee; font-size: 12px; }
            .text-right { text-align: right; }
            .totals { width: 280px; margin-left: auto; }
            .totals tr td { padding: 4px 8px; }
            .totals .total-row td { font-size: 16px; font-weight: bold; border-top: 2px solid #333; padding-top: 10px; }
            .payment-info { background: #f9f9f9; padding: 12px; border-radius: 5px; margin-bottom: 20px; }
            .payment-info h3 { margin: 0 0 6px 0; font-size: 12px; text-transform: uppercase; color: #666; }
            .payment-info p { margin: 2px 0; font-size: 12px; }
            .footer { text-align: center; margin-top: 20px; padding-top: 12px; border-top: 1px dashed #ccc; font-size: 11px; color: #777; }
            .footer p { margin: 3px 0; }
            @media print { body { padding: 15px; } .page-break { page-break-after: always; } }
          </style>
        </head>
        <body>
          ${invoiceHtml}
          ${copies === 2 ? `<hr class="page-break" />${invoiceHtml}` : ''}
        </body>
      </html>
    `)
    printWindow.document.close()
    printWindow.print()
  }

  const paymentMethodOptions: { value: PaymentMethod; label: string }[] = [
    { value: 'efectivo', label: 'EFECTIVO' },
    { value: 'tarjeta', label: 'TARJETA' },
    { value: 'transferencia', label: 'TRANSFERENCIA' },
    { value: 'addi', label: 'ADDI' },
    { value: 'sistecredito', label: 'SISTECREDITO' },
  ]

  return (
    <div className="flex gap-3 h-full min-h-[600px]">
      {/* ── LEFT PANEL: Invoice Data ── */}
      <div className="w-72 flex-shrink-0 flex flex-col rounded-lg border border-border overflow-hidden shadow-sm">
        {/* Header */}
        <div className="flex items-center justify-between px-4 py-2.5 bg-[#2d9e8c]">
          <span className="text-white font-semibold text-sm">Factura de Venta</span>
          <button
            onClick={onToggleMode}
            className="flex items-center gap-1.5 bg-white/20 hover:bg-white/30 text-white text-xs font-medium px-2.5 py-1 rounded-full transition-colors"
            title="Cambiar a modo rápido"
          >
            <span className="w-4 h-4 bg-white rounded-full flex items-center justify-center">
              <span className="w-2.5 h-2.5 bg-[#2d9e8c] rounded-full" />
            </span>
            Turno
          </button>
        </div>

        {/* Form */}
        <div className="flex-1 bg-card p-3 space-y-2.5 overflow-y-auto">
          {/* Tipo documento */}
          <div>
            <Select defaultValue="factura_venta">
              <SelectTrigger className="h-8 text-xs bg-background border-border">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="factura_venta">Factura de Venta</SelectItem>
                <SelectItem value="remision">Remisión</SelectItem>
                <SelectItem value="nota_debito">Nota Débito</SelectItem>
              </SelectContent>
            </Select>
          </div>

          {/* Fecha + No. Factura */}
          <div className="grid grid-cols-2 gap-2">
            <div>
              <label className="text-xs text-muted-foreground mb-1 block">Fecha</label>
              <Input
                value={todayStr}
                readOnly
                className="h-8 text-xs bg-background border-border"
              />
            </div>
            <div>
              <label className="text-xs text-muted-foreground mb-1 block">No. Factura</label>
              <div className="relative">
                <Input
                  value={completedSale?.invoiceNumber ?? ''}
                  readOnly
                  placeholder="Auto"
                  className="h-8 text-xs bg-background border-border pr-7"
                />
                <Search className="absolute right-2 top-1/2 -translate-y-1/2 h-3.5 w-3.5 text-muted-foreground" />
              </div>
            </div>
          </div>

          {/* Cliente */}
          <div>
            <label className="text-xs text-muted-foreground mb-1 block">Cliente</label>
            <div className="relative" ref={customerDropdownRef}>
              <div className="flex items-center gap-1">
                <div className="relative flex-1">
                  <Input
                    value={customerSearch}
                    onChange={(e) => handleCustomerSearch(e.target.value)}
                    placeholder="CLIENTES VARIOS"
                    className="h-8 text-xs bg-background border-border pr-16"
                  />
                  {selectedCustomer && (
                    <button
                      onClick={handleClearCustomer}
                      className="absolute right-6 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground"
                    >
                      <X className="h-3.5 w-3.5" />
                    </button>
                  )}
                  <span className="absolute right-2 top-1/2 -translate-y-1/2 text-muted-foreground text-xs">▼</span>
                </div>
                <Button
                  variant="outline"
                  size="icon"
                  className="h-8 w-8 border-border flex-shrink-0"
                  onClick={() => { setCustomerSearch(''); setShowCustomerDropdown(true); handleCustomerSearch(' ') }}
                  title="Buscar cliente"
                >
                  <Search className="h-3.5 w-3.5" />
                </Button>
              </div>
              {showCustomerDropdown && customerResults.length > 0 && (
                <div className="absolute z-50 top-full left-0 right-0 bg-popover border border-border rounded-md shadow-lg mt-0.5 max-h-44 overflow-y-auto">
                  {customerResults.map(cust => (
                    <button
                      key={cust.id}
                      onClick={() => handleSelectCustomer(cust)}
                      className="w-full text-left px-3 py-1.5 text-xs hover:bg-accent transition-colors border-b border-border/50 last:border-b-0"
                    >
                      <span className="font-medium">{cust.name}</span>
                      {cust.cedula && <span className="text-muted-foreground ml-1">— {cust.cedula}</span>}
                      {cust.phone && <span className="text-muted-foreground ml-1">| {cust.phone}</span>}
                    </button>
                  ))}
                </div>
              )}
              {isSearchingCustomers && (
                <div className="absolute z-50 top-full left-0 right-0 bg-popover border border-border rounded-md p-2 text-xs text-muted-foreground mt-0.5">
                  Buscando...
                </div>
              )}
            </div>
          </div>

          {/* Precio de venta + Cliente name */}
          <div className="grid grid-cols-2 gap-2">
            <div>
              <label className="text-xs text-muted-foreground mb-1 block">Precio de Venta</label>
              <Select defaultValue="precio1">
                <SelectTrigger className="h-8 text-xs bg-background border-border">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="precio1">PRECIO 1</SelectItem>
                  <SelectItem value="precio2">PRECIO 2</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div>
              <label className="text-xs text-muted-foreground mb-1 block">Cliente</label>
              <Input
                value={selectedCustomer?.name ?? ''}
                readOnly
                placeholder=""
                className="h-8 text-xs bg-background border-border"
              />
            </div>
          </div>

          {/* Identificación */}
          <div>
            <label className="text-xs text-muted-foreground mb-1 block">Identificación</label>
            <Input
              value={selectedCustomer?.cedula ?? ''}
              readOnly
              placeholder=""
              className="h-8 text-xs bg-background border-border"
            />
          </div>

          {/* Celular + Método de pago */}
          <div className="grid grid-cols-2 gap-2">
            <div>
              <label className="text-xs text-muted-foreground mb-1 block">Celular</label>
              <Input
                value={selectedCustomer?.phone ?? ''}
                readOnly
                placeholder=""
                className="h-8 text-xs bg-background border-border"
              />
            </div>
            <div>
              <label className="text-xs text-muted-foreground mb-1 block">Metodo de Pago</label>
              <Select
                value={paymentMethod}
                onValueChange={(val) => {
                  setPaymentMethod(val as PaymentMethod)
                  setPaymentMethodLabel(val.toUpperCase())
                }}
              >
                <SelectTrigger className="h-8 text-xs bg-background border-border">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {paymentMethodOptions.map(opt => (
                    <SelectItem key={opt.value} value={opt.value} className="text-xs">
                      {opt.label}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </div>

          {/* Forma de pago + Remisión */}
          <div className="grid grid-cols-2 gap-2">
            <div>
              <label className="text-xs text-muted-foreground mb-1 block">Forma de Pago</label>
              <div className="flex items-center gap-1">
                <Select
                  value={formaPago}
                  onValueChange={(val) => setFormaPago(val as 'contado' | 'credito')}
                >
                  <SelectTrigger className="h-8 text-xs bg-background border-border flex-1">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="contado" className="text-xs">Contado</SelectItem>
                    <SelectItem value="credito" className="text-xs">Crédito</SelectItem>
                  </SelectContent>
                </Select>
                <button
                  className="text-muted-foreground hover:text-foreground"
                  title="Configurar forma de pago"
                >
                  <Settings2 className="h-4 w-4 text-red-500" />
                </button>
              </div>
            </div>
            <div>
              <label className="text-xs text-muted-foreground mb-1 block">Remisión</label>
              <button
                onClick={() => setRemision(!remision)}
                className={`w-full h-8 text-xs font-medium rounded-md border transition-colors ${
                  remision
                    ? 'bg-[#2d9e8c] text-white border-[#2d9e8c]'
                    : 'bg-muted text-muted-foreground border-border'
                }`}
              >
                {remision ? 'SÍ' : 'NO'}
              </button>
            </div>
          </div>

          {/* IVA toggle */}
          <div className="flex items-center justify-between pt-1 border-t border-border/50">
            <span className="text-xs text-muted-foreground">Aplicar IVA (19%)</span>
            <button
              onClick={() => setApplyIva(!applyIva)}
              className={`relative inline-flex h-5 w-9 items-center rounded-full transition-colors ${
                applyIva ? 'bg-[#2d9e8c]' : 'bg-muted-foreground/30'
              }`}
            >
              <span className={`inline-block h-3.5 w-3.5 transform rounded-full bg-white transition-transform ${applyIva ? 'translate-x-4' : 'translate-x-0.5'}`} />
            </button>
          </div>
        </div>
      </div>

      {/* ── RIGHT PANEL: Products + Totals ── */}
      <div className="flex-1 flex flex-col gap-3 min-w-0">
        {/* Product search row */}
        <div className="flex items-end gap-2">
          <div className="flex-1">
            <label className="text-xs text-muted-foreground mb-1 block">Producto/Artículo (F4)</label>
            <div className="relative">
              <Input
                ref={productSearchRef}
                value={productSearch}
                onChange={(e) => {
                  setProductSearch(e.target.value)
                  setShowProductDropdown(e.target.value.length > 0)
                }}
                onKeyDown={handleProductSearchKey}
                onFocus={() => productSearch.length > 0 && setShowProductDropdown(true)}
                placeholder="Seleccione un producto"
                className="h-9 text-sm bg-background border-border pr-9"
              />
              <Search className="absolute right-2.5 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
              {showProductDropdown && filteredProducts.length > 0 && (
                <div className="absolute z-50 top-full left-0 right-0 bg-popover border border-border rounded-md shadow-lg mt-0.5 max-h-52 overflow-y-auto">
                  {filteredProducts.map(p => (
                    <button
                      key={p.id}
                      onClick={() => handleAddProductFromSearch(p.id)}
                      className="w-full text-left px-3 py-1.5 text-xs hover:bg-accent transition-colors border-b border-border/50 last:border-b-0"
                    >
                      <span className="font-medium">{p.name}</span>
                      <span className="text-muted-foreground ml-2">{p.sku}</span>
                      <span className="float-right font-semibold text-[#2d9e8c]">{formatCOP(p.salePrice)}</span>
                    </button>
                  ))}
                </div>
              )}
            </div>
          </div>
          <div className="w-20">
            <label className="text-xs text-muted-foreground mb-1 block">Cantidad</label>
            <Input
              type="number"
              min={1}
              value={productQty}
              onChange={(e) => setProductQty(Math.max(1, parseInt(e.target.value) || 1))}
              className="h-9 text-sm bg-background border-border text-center"
            />
          </div>
          <div className="w-28">
            <label className="text-xs text-muted-foreground mb-1 block">Precio Venta</label>
            <Input
              type="number"
              value={productPrice || ''}
              onChange={(e) => setProductPrice(parseFloat(e.target.value) || 0)}
              placeholder="$0"
              className="h-9 text-sm bg-background border-border"
            />
          </div>
          <Button
            className="h-9 w-9 p-0 bg-[#2d9e8c] hover:bg-[#268a7a] text-white flex-shrink-0"
            onClick={() => {
              if (filteredProducts.length > 0) handleAddProductFromSearch(filteredProducts[0].id)
            }}
            title="Agregar producto"
          >
            <Plus className="h-5 w-5" />
          </Button>
        </div>

        {/* Products table */}
        <div className="flex-1 border border-border rounded-lg overflow-hidden bg-card">
          <div className="overflow-x-auto">
            <table className="w-full text-xs">
              <thead>
                <tr className="bg-muted/40 border-b border-border">
                  <th className="w-9 px-1.5 py-2" />
                  <th className="w-8 px-1.5 py-2 text-center font-semibold text-foreground/70">#</th>
                  <th className="w-16 px-2 py-2 text-left font-semibold text-foreground/70">Codigo</th>
                  <th className="px-2 py-2 text-left font-semibold text-foreground/70">Descripción</th>
                  <th className="w-24 px-2 py-2 text-center font-semibold text-foreground/70">Cantidad</th>
                  <th className="w-16 px-2 py-2 text-right font-semibold text-foreground/70">IVA</th>
                  <th className="w-28 px-2 py-2 text-center font-semibold text-foreground/70">ValorUnitario</th>
                  <th className="w-20 px-2 py-2 text-right font-semibold text-foreground/70">Subtotal</th>
                  <th className="w-20 px-2 py-2 text-right font-semibold text-foreground/70">Total</th>
                  <th className="w-8 px-1.5 py-2 text-center font-semibold text-foreground/70">Ref</th>
                </tr>
              </thead>
              <tbody>
                {cart.map((item, idx) => {
                  const effectivePrice = itemPrices[item.product.id] ?? item.product.salePrice
                  const itemSubtotal = effectivePrice * item.quantity * (1 - item.discount / 100)
                  const itemIva = applyIva ? itemSubtotal * TAX_RATE : 0
                  const itemTotal = itemSubtotal + itemIva
                  return (
                    <tr key={item.product.id} className="border-b border-border/50 hover:bg-muted/20 transition-colors">
                      {/* Delete */}
                      <td className="px-1.5 py-1">
                        <button
                          onClick={() => {
                            removeFromCart(item.product.id)
                            setItemPrices(prev => { const n = { ...prev }; delete n[item.product.id]; return n })
                          }}
                          className="flex items-center justify-center w-6 h-6 rounded bg-red-500 hover:bg-red-600 text-white transition-colors"
                        >
                          <Trash2 className="h-3 w-3" />
                        </button>
                      </td>
                      {/* # */}
                      <td className="px-1.5 py-1 text-center text-muted-foreground">{idx + 1}</td>
                      {/* Código */}
                      <td className="px-2 py-1 text-muted-foreground font-mono">
                        {item.product.articulo || item.product.sku}
                      </td>
                      {/* Descripción */}
                      <td className="px-2 py-1 font-medium max-w-[160px] truncate">
                        {item.product.name}
                      </td>
                      {/* Cantidad — editable input */}
                      <td className="px-1.5 py-1">
                        <input
                          type="number"
                          min={1}
                          value={item.quantity}
                          onChange={(e) => {
                            const v = parseInt(e.target.value) || 1
                            updateCartQuantity(item.product.id, Math.max(1, v))
                          }}
                          onFocus={(e) => e.target.select()}
                          className="w-full h-7 px-2 text-center text-xs border border-border rounded bg-background focus:outline-none focus:ring-1 focus:ring-[#2d9e8c] focus:border-[#2d9e8c]"
                        />
                      </td>
                      {/* IVA — read only */}
                      <td className="px-2 py-1 text-right text-muted-foreground">
                        {applyIva ? Math.round(itemIva).toLocaleString('es-CO') : 0}
                      </td>
                      {/* ValorUnitario — editable input */}
                      <td className="px-1.5 py-1">
                        <input
                          type="number"
                          min={0}
                          value={effectivePrice || ''}
                          onChange={(e) => {
                            const v = parseFloat(e.target.value) || 0
                            setItemPrices(prev => ({ ...prev, [item.product.id]: v }))
                          }}
                          onFocus={(e) => e.target.select()}
                          className="w-full h-7 px-2 text-right text-xs border border-border rounded bg-background focus:outline-none focus:ring-1 focus:ring-[#2d9e8c] focus:border-[#2d9e8c]"
                        />
                      </td>
                      {/* Subtotal */}
                      <td className="px-2 py-1 text-right">
                        {Math.round(itemSubtotal).toLocaleString('es-CO')}
                      </td>
                      {/* Total */}
                      <td className="px-2 py-1 text-right font-medium">
                        {Math.round(itemTotal).toLocaleString('es-CO')}
                      </td>
                      {/* Ref — pencil icon */}
                      <td className="px-1.5 py-1 text-center">
                        <Pencil className="h-3.5 w-3.5 text-blue-500 mx-auto cursor-pointer hover:text-blue-700" />
                      </td>
                    </tr>
                  )
                })}
                {cart.length === 0 && (
                  <tr>
                    <td colSpan={10} className="px-4 py-8 text-center text-muted-foreground text-xs">
                      Agregue productos para comenzar la factura
                    </td>
                  </tr>
                )}
              </tbody>
              <tfoot>
                <tr className="border-t-2 border-border bg-muted/30">
                  <td className="px-1.5 py-1.5">
                    <input type="checkbox" defaultChecked className="rounded" />
                  </td>
                  <td colSpan={3} className="px-2 py-1.5 text-xs font-semibold">
                    Tabulación (F2)
                  </td>
                  <td className="px-2 py-1.5 text-center text-xs font-bold">
                    {cart.reduce((s, i) => s + i.quantity, 0)}
                  </td>
                  <td className="px-2 py-1.5" />
                  <td className="px-2 py-1.5 text-right text-xs font-semibold text-muted-foreground">
                    Totales
                  </td>
                  <td className="px-2 py-1.5 text-right text-xs font-bold">
                    {cart.length > 0 ? `$${Math.round(subtotal).toLocaleString('es-CO')}` : '$0'}
                  </td>
                  <td className="px-2 py-1.5 text-right text-xs font-bold">
                    {cart.length > 0 ? `$${Math.round(total).toLocaleString('es-CO')}` : '$0'}
                  </td>
                  <td />
                </tr>
              </tfoot>
            </table>
          </div>
        </div>

        {/* Totals + payment + actions */}
        <div className="border border-border rounded-lg bg-card p-4">
          {/* Subtotal / IVA / Total — right-aligned like the image */}
          <div className="space-y-1 mb-3">
            <div className="flex justify-between text-sm">
              <span className="font-semibold text-right flex-1">Subtotal:</span>
              <span className="w-28 text-right">${Math.round(subtotal).toLocaleString('es-CO')}</span>
            </div>
            <div className="flex justify-between text-sm">
              <span className="font-semibold text-right flex-1">IVA:</span>
              <span className="w-28 text-right">${Math.round(tax).toLocaleString('es-CO')}</span>
            </div>
            <div className="flex justify-between text-sm font-bold mt-1">
              <span className="text-right flex-1">Total:</span>
              <span className="w-28 text-right text-xl">${Math.round(total).toLocaleString('es-CO')}</span>
            </div>
          </div>

          {/* Efectivo input */}
          <div className="flex items-center justify-between gap-3 mb-2">
            <span className="text-sm font-semibold flex-1 text-right">Efectivo (F11):</span>
            <input
              ref={cashInputRef}
              type="number"
              value={amountPaid}
              onChange={(e) => setAmountPaid(e.target.value)}
              onFocus={(e) => e.target.select()}
              placeholder="$0"
              disabled={formaPago === 'credito'}
              className="w-28 h-9 px-3 text-right text-sm border border-green-200 dark:border-green-800 rounded-md bg-green-50 dark:bg-green-950/30 focus:outline-none focus:ring-1 focus:ring-[#2d9e8c] focus:border-[#2d9e8c] disabled:opacity-50"
            />
          </div>

          {/* Cambio */}
          <div className="flex items-center justify-between mb-3">
            <span className="text-sm font-semibold flex-1 text-right">Cambio:</span>
            <span className={`w-28 text-right text-xl font-bold ${change > 0 ? 'text-[#2d9e8c]' : 'text-[#2d9e8c]'}`}>
              ${Math.round(change).toLocaleString('es-CO')}
            </span>
          </div>

          {/* Action buttons — 2 buttons matching the image */}
          <div className="flex gap-2 justify-end">
            <Button
              size="sm"
              onClick={handleNewInvoice}
              className="h-9 text-xs gap-1.5 bg-slate-600 hover:bg-slate-700 text-white px-4"
            >
              <FileText className="h-3.5 w-3.5" />
              Nueva Factura (F3)
            </Button>
            <Button
              size="sm"
              onClick={() => completedSale ? handlePrint(completedSale) : handleCompleteSale()}
              disabled={isProcessing || cart.length === 0}
              className="h-9 text-xs gap-1.5 bg-blue-600 hover:bg-blue-700 text-white px-4"
            >
              <Printer className="h-3.5 w-3.5" />
              {completedSale ? 'Imprimir (F12)' : isProcessing ? 'Guardando...' : 'Imprimir (F12)'}
            </Button>
          </div>
        </div>
      </div>
    </div>
  )
}
