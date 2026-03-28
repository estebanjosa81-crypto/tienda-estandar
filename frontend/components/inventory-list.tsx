'use client'

import React from "react"

import { useState, useEffect } from 'react'
import { useStore, getStockStatus } from '@/lib/store'
import { api } from '@/lib/api'
import { type Product, type Category, type ProductType, type Sede } from '@/lib/types'
import { PRODUCT_TYPES, FIELD_DEFINITIONS, getFieldsForProductType } from '@/lib/product-config'
import { formatCOP } from '@/lib/utils'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog'
import { Label } from '@/components/ui/label'
import { Textarea } from '@/components/ui/textarea'
import { Checkbox } from '@/components/ui/checkbox'
import { CloudinaryUpload } from '@/components/ui/cloudinary-upload'
import {
  Search,
  Plus,
  Edit2,
  Trash2,
  Package,
  Filter,
  Tags,
  ScanLine,
  Smartphone,
  Upload,
  MapPin,
  ChevronDown,
  ChevronLeft,
  ChevronRight,
  Settings2,
  FileDown,
  Eye,
  EyeOff,
  Pencil,
  FileSpreadsheet,
  CheckCircle2,
  AlertTriangle,
  XCircle,
} from 'lucide-react'
import { toast } from 'sonner'
import { BarcodeScanner } from '@/components/barcode-scanner'
import { RemoteScanner } from '@/components/remote-scanner'
import { BulkUploadDialog } from '@/components/bulk-upload-dialog'

export function InventoryList() {
  const { products, isLoadingProducts, fetchProducts, addProduct, updateProduct, deleteProduct, categories, fetchCategories, addCategory, updateCategory, deleteCategory, inventoryStockFilter, inventorySearchQuery, clearInventoryFilters, sedes, fetchSedes, addSede, updateSede, deleteSede } = useStore()
  const [search, setSearch] = useState('')
  const [categoryFilter, setCategoryFilter] = useState<string>('all')
  const [stockFilter, setStockFilter] = useState<string>('all')
  const [typeFilter, setTypeFilter] = useState<string>('all')
  const [activeSede, setActiveSede] = useState<string>('all')
  const [isAddDialogOpen, setIsAddDialogOpen] = useState(false)
  const [isEditDialogOpen, setIsEditDialogOpen] = useState(false)
  const [isDeleteDialogOpen, setIsDeleteDialogOpen] = useState(false)
  const [isCategoryDialogOpen, setIsCategoryDialogOpen] = useState(false)
  const [isBulkUploadOpen, setIsBulkUploadOpen] = useState(false)
  const [isSedeDialogOpen, setIsSedeDialogOpen] = useState(false)
  const [selectedProduct, setSelectedProduct] = useState<Product | null>(null)
  const [isExporting, setIsExporting] = useState(false)
  const [isExportingExcel, setIsExportingExcel] = useState(false)
  const [currentPage, setCurrentPage] = useState(1)
  const ITEMS_PER_PAGE = 100

  const handleExportCsv = async () => {
    setIsExporting(true)
    try {
      const params: Record<string, string> = {}
      if (search) params.search = search
      if (categoryFilter !== 'all') params.category = categoryFilter
      if (stockFilter !== 'all') params.stockStatus = stockFilter
      if (typeFilter !== 'all') params.productType = typeFilter

      const blob = await api.exportProductsCSV(params)
      const url = URL.createObjectURL(blob)
      const a = document.createElement('a')
      a.href = url
      a.download = `inventario_${new Date().toISOString().split('T')[0]}.csv`
      a.click()
      URL.revokeObjectURL(url)
      toast.success('Inventario exportado correctamente')
    } catch {
      toast.error('Error al exportar el inventario')
    } finally {
      setIsExporting(false)
    }
  }
  const handleExportExcel = async () => {
    setIsExportingExcel(true)
    try {
      const ExcelJS = (await import('exceljs')).default
      const workbook = new ExcelJS.Workbook()
      workbook.creator = 'Sistema de Inventario'
      workbook.created = new Date()

      const dateStr = new Date().toLocaleDateString('es-CO', { year: 'numeric', month: 'long', day: 'numeric' })
      const dateFile = new Date().toISOString().split('T')[0]

      // ── COLORS ────────────────────────────────────────────────────────────
      const TEAL       = '2d9e8c'
      const TEAL_LIGHT = 'e6f4f2'
      const RED        = 'dc2626'
      const RED_LIGHT  = 'fef2f2'
      const AMBER      = 'd97706'
      const AMBER_LIGHT= 'fffbeb'
      const GREEN      = '16a34a'
      const GREEN_LIGHT= 'f0fdf4'
      const GRAY_HEADER= 'f1f5f9'
      const GRAY_ROW   = 'f8fafc'

      const headerFont   = { bold: true, color: { argb: 'FFFFFFFF' }, size: 11 }
      const titleFont    = { bold: true, size: 13, color: { argb: 'FF' + TEAL } }
      const subTitleFont = { bold: true, size: 11 }
      const borderStyle = 'thin' as const
      const allBorders = {
        top:    { style: borderStyle },
        left:   { style: borderStyle },
        bottom: { style: borderStyle },
        right:  { style: borderStyle },
      }

      // ═══════════════════════════════════════════════════════════════
      // HOJA 1 — RESUMEN
      // ═══════════════════════════════════════════════════════════════
      const ws1 = workbook.addWorksheet('Resumen', {
        properties: { tabColor: { argb: 'FF' + TEAL } },
      })
      ws1.columns = [
        { width: 28 }, { width: 22 }, { width: 22 }, { width: 22 }, { width: 22 },
      ]

      // Title block
      ws1.mergeCells('A1:E1')
      const titleCell = ws1.getCell('A1')
      titleCell.value = '📦 INFORME DE INVENTARIO'
      titleCell.font = { bold: true, size: 16, color: { argb: 'FFFFFFFF' } }
      titleCell.alignment = { horizontal: 'center', vertical: 'middle' }
      titleCell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF' + TEAL } }
      ws1.getRow(1).height = 36

      ws1.mergeCells('A2:E2')
      const subCell = ws1.getCell('A2')
      subCell.value = `Generado el ${dateStr}`
      subCell.font = { italic: true, size: 10, color: { argb: 'FF64748b' } }
      subCell.alignment = { horizontal: 'center' }
      subCell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF' + TEAL_LIGHT } }
      ws1.getRow(2).height = 20

      ws1.getRow(3).height = 14

      // KPI Cards row
      const totalProducts = products.length
      const totalStock = products.reduce((s, p) => s + p.stock, 0)
      const totalValue = products.reduce((s, p) => s + p.purchasePrice * p.stock, 0)
      const totalSaleValue = products.reduce((s, p) => s + p.salePrice * p.stock, 0)
      const agotados = products.filter(p => p.stock === 0).length
      const bajoStock = products.filter(p => p.stock > 0 && p.stock <= p.reorderPoint).length
      const suficiente = products.filter(p => p.stock > p.reorderPoint).length

      const kpiHeaders = ['TOTAL PRODUCTOS', 'TOTAL UNIDADES', 'VALOR COSTO', 'VALOR VENTA', 'MARGEN BRUTO']
      const kpiValues  = [
        totalProducts,
        totalStock,
        `$${totalValue.toLocaleString('es-CO')}`,
        `$${totalSaleValue.toLocaleString('es-CO')}`,
        `$${(totalSaleValue - totalValue).toLocaleString('es-CO')}`,
      ]

      const kpiRow4 = ws1.getRow(4)
      const kpiRow5 = ws1.getRow(5)
      kpiRow4.height = 18
      kpiRow5.height = 28

      kpiHeaders.forEach((h, i) => {
        const col = String.fromCharCode(65 + i)
        const cellH = ws1.getCell(`${col}4`)
        cellH.value = h
        cellH.font = { bold: true, size: 9, color: { argb: 'FF64748b' } }
        cellH.alignment = { horizontal: 'center' }
        cellH.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF' + GRAY_HEADER } }
        cellH.border = allBorders

        const cellV = ws1.getCell(`${col}5`)
        cellV.value = kpiValues[i]
        cellV.font = { bold: true, size: 13, color: { argb: 'FF' + TEAL } }
        cellV.alignment = { horizontal: 'center', vertical: 'middle' }
        cellV.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF' + TEAL_LIGHT } }
        cellV.border = allBorders
      })

      ws1.getRow(6).height = 14

      // Stock status summary
      const stockRow = 7
      ;['Estado Stock', 'Cantidad', 'Porcentaje'].forEach((h, i) => {
        const cell = ws1.getCell(stockRow, i + 1)
        cell.value = h
        cell.font = { ...subTitleFont, color: { argb: 'FFFFFFFF' } }
        cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF334155' } }
        cell.alignment = { horizontal: 'center' }
        cell.border = allBorders
      })
      const stockRows = [
        { label: '✅ Suficiente', count: suficiente, color: GREEN_LIGHT, textColor: GREEN },
        { label: '⚠️  Bajo stock', count: bajoStock,  color: AMBER_LIGHT, textColor: AMBER },
        { label: '❌ Agotado',    count: agotados,   color: RED_LIGHT,   textColor: RED },
      ]
      stockRows.forEach(({ label, count, color, textColor }, i) => {
        const r = stockRow + 1 + i
        ;[
          { col: 1, val: label,                                           align: 'left'   },
          { col: 2, val: count,                                           align: 'center' },
          { col: 3, val: totalProducts ? `${((count / totalProducts) * 100).toFixed(1)}%` : '0%', align: 'center' },
        ].forEach(({ col, val, align }) => {
          const cell = ws1.getCell(r, col)
          cell.value = val
          cell.font = { bold: col === 1, color: { argb: 'FF' + textColor } }
          cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF' + color } }
          cell.alignment = { horizontal: align as 'left' | 'center' | 'right' }
          cell.border = allBorders
        })
      })

      ws1.getRow(stockRow + 4).height = 14

      // Category summary table
      const catHeaderRow = stockRow + 5
      ;['Categoría', 'Productos', 'Unidades', 'Valor Costo', 'Valor Venta'].forEach((h, i) => {
        const cell = ws1.getCell(catHeaderRow, i + 1)
        cell.value = h
        cell.font = headerFont
        cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF' + TEAL } }
        cell.alignment = { horizontal: 'center' }
        cell.border = allBorders
      })

      const categoryGroups: Record<string, { count: number; units: number; cost: number; sale: number }> = {}
      products.forEach(p => {
        const catName = getCategoryName(p.category)
        if (!categoryGroups[catName]) categoryGroups[catName] = { count: 0, units: 0, cost: 0, sale: 0 }
        categoryGroups[catName].count++
        categoryGroups[catName].units += p.stock
        categoryGroups[catName].cost  += p.purchasePrice * p.stock
        categoryGroups[catName].sale  += p.salePrice * p.stock
      })

      const sortedCats = Object.entries(categoryGroups).sort((a, b) => b[1].sale - a[1].sale)
      sortedCats.forEach(([catName, data], i) => {
        const r = catHeaderRow + 1 + i
        const isOdd = i % 2 === 0
        ;[
          { val: catName,                                  align: 'left',   fmt: undefined },
          { val: data.count,                               align: 'center', fmt: undefined },
          { val: data.units,                               align: 'center', fmt: undefined },
          { val: `$${data.cost.toLocaleString('es-CO')}`, align: 'right',  fmt: undefined },
          { val: `$${data.sale.toLocaleString('es-CO')}`, align: 'right',  fmt: undefined },
        ].forEach(({ val, align }, ci) => {
          const cell = ws1.getCell(r, ci + 1)
          cell.value = val
          cell.alignment = { horizontal: align as 'left' | 'center' | 'right' }
          cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: isOdd ? 'FFFFFFFF' : 'FF' + GRAY_ROW } }
          cell.border = allBorders
        })
      })

      // Totals row for categories
      const catTotalRow = catHeaderRow + 1 + sortedCats.length
      const totCost = sortedCats.reduce((s, [, d]) => s + d.cost, 0)
      const totSale = sortedCats.reduce((s, [, d]) => s + d.sale, 0)
      ;[
        { val: 'TOTAL', align: 'left' },
        { val: sortedCats.reduce((s, [, d]) => s + d.count, 0), align: 'center' },
        { val: sortedCats.reduce((s, [, d]) => s + d.units, 0), align: 'center' },
        { val: `$${totCost.toLocaleString('es-CO')}`, align: 'right' },
        { val: `$${totSale.toLocaleString('es-CO')}`, align: 'right' },
      ].forEach(({ val, align }, ci) => {
        const cell = ws1.getCell(catTotalRow, ci + 1)
        cell.value = val
        cell.font = { bold: true, color: { argb: 'FFFFFFFF' } }
        cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF334155' } }
        cell.alignment = { horizontal: align as 'left' | 'center' | 'right' }
        cell.border = allBorders
      })

      // ═══════════════════════════════════════════════════════════════
      // HOJA 2 — INVENTARIO COMPLETO
      // ═══════════════════════════════════════════════════════════════
      const ws2 = workbook.addWorksheet('Inventario', {
        properties: { tabColor: { argb: 'FF' + TEAL } },
        views: [{ state: 'frozen', xSplit: 0, ySplit: 2 }],
      })

      ws2.columns = [
        { key: 'num',          width: 5,  header: '#' },
        { key: 'sku',          width: 14, header: 'SKU' },
        { key: 'articulo',     width: 14, header: 'Código/Artículo' },
        { key: 'barcode',      width: 16, header: 'Código de Barras' },
        { key: 'name',         width: 36, header: 'Nombre del Producto' },
        { key: 'category',     width: 18, header: 'Categoría' },
        { key: 'productType',  width: 16, header: 'Tipo' },
        { key: 'brand',        width: 16, header: 'Marca' },
        { key: 'purchasePrice',width: 16, header: 'Precio Costo' },
        { key: 'salePrice',    width: 16, header: 'Precio Venta' },
        { key: 'margin',       width: 12, header: 'Margen %' },
        { key: 'stock',        width: 10, header: 'Stock' },
        { key: 'reorderPoint', width: 14, header: 'Punto Reorden' },
        { key: 'stockStatus',  width: 14, header: 'Estado Stock' },
        { key: 'stockValue',   width: 18, header: 'Valor Inventario' },
        { key: 'supplier',     width: 20, header: 'Proveedor' },
        { key: 'sede',         width: 14, header: 'Sede' },
        { key: 'location',     width: 18, header: 'Ubicación' },
        { key: 'entryDate',    width: 14, header: 'Fecha Ingreso' },
        { key: 'notes',        width: 28, header: 'Notas' },
      ]

      // Title row
      ws2.mergeCells('A1:T1')
      const ws2Title = ws2.getCell('A1')
      ws2Title.value = `INVENTARIO COMPLETO — ${dateStr}`
      ws2Title.font = { bold: true, size: 13, color: { argb: 'FFFFFFFF' } }
      ws2Title.alignment = { horizontal: 'center', vertical: 'middle' }
      ws2Title.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF' + TEAL } }
      ws2.getRow(1).height = 28

      // Header row (row 2)
      const headerRow = ws2.getRow(2)
      headerRow.height = 22
      ws2.columns.forEach((col, i) => {
        const cell = headerRow.getCell(i + 1)
        cell.value = Array.isArray(col.header) ? col.header.join(' ') : (col.header ?? '')
        cell.font = headerFont
        cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF334155' } }
        cell.alignment = { horizontal: 'center', vertical: 'middle', wrapText: false }
        cell.border = allBorders
      })

      // Data rows
      const allProducts = [...products].sort((a, b) => {
        const catA = getCategoryName(a.category)
        const catB = getCategoryName(b.category)
        return catA.localeCompare(catB) || a.name.localeCompare(b.name)
      })

      allProducts.forEach((p, i) => {
        const status = getStockStatus(p)
        const margin = p.salePrice > 0
          ? Math.round(((p.salePrice - p.purchasePrice) / p.salePrice) * 100)
          : 0
        const sedeName = sedes.find(s => s.id === p.sedeId)?.name ?? ''
        const isOdd = i % 2 === 0

        let rowBg = isOdd ? 'FFFFFFFF' : 'FF' + GRAY_ROW
        let stockColor: string | null = null
        if (status === 'agotado') stockColor = RED
        else if (status === 'bajo') stockColor = AMBER
        else stockColor = GREEN

        const row = ws2.addRow({
          num:           i + 1,
          sku:           p.sku,
          articulo:      p.articulo ?? '',
          barcode:       p.barcode ?? '',
          name:          p.name,
          category:      getCategoryName(p.category),
          productType:   p.productType ?? '',
          brand:         p.brand ?? '',
          purchasePrice: p.purchasePrice,
          salePrice:     p.salePrice,
          margin:        margin / 100,
          stock:         p.stock,
          reorderPoint:  p.reorderPoint,
          stockStatus:   status === 'agotado' ? 'Agotado' : status === 'bajo' ? 'Bajo stock' : 'Suficiente',
          stockValue:    p.purchasePrice * p.stock,
          supplier:      p.supplier ?? '',
          sede:          sedeName,
          location:      p.locationInStore ?? '',
          entryDate:     p.entryDate ? new Date(p.entryDate).toLocaleDateString('es-CO') : '',
          notes:         p.notes ?? '',
        })
        row.height = 18
        row.eachCell({ includeEmpty: true }, (cell, colNum) => {
          cell.border = allBorders
          cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: rowBg } }

          // Number formatting
          if (colNum === 9 || colNum === 10 || colNum === 15) {
            cell.numFmt = '"$"#,##0'
          }
          if (colNum === 11) {
            cell.numFmt = '0%'
          }

          // Stock status cell color
          if (colNum === 14 && stockColor) {
            const bg = status === 'agotado' ? RED_LIGHT : status === 'bajo' ? AMBER_LIGHT : GREEN_LIGHT
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF' + bg } }
            cell.font = { bold: true, color: { argb: 'FF' + stockColor } }
          }

          // Alignment
          if ([1, 12, 13].includes(colNum)) cell.alignment = { horizontal: 'center' }
          else if ([9, 10, 11, 15].includes(colNum)) cell.alignment = { horizontal: 'right' }
        })
      })

      // Summary/totals row
      const summaryRow = ws2.addRow({
        num: '',
        sku: '',
        articulo: '',
        barcode: '',
        name: `TOTAL — ${allProducts.length} productos`,
        category: '',
        productType: '',
        brand: '',
        purchasePrice: '',
        salePrice: '',
        margin: '',
        stock: allProducts.reduce((s, p) => s + p.stock, 0),
        reorderPoint: '',
        stockStatus: '',
        stockValue: allProducts.reduce((s, p) => s + p.purchasePrice * p.stock, 0),
        supplier: '',
        sede: '',
        location: '',
        entryDate: '',
        notes: '',
      })
      summaryRow.height = 22
      summaryRow.eachCell({ includeEmpty: true }, (cell, colNum) => {
        cell.font = { bold: true, color: { argb: 'FFFFFFFF' } }
        cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF334155' } }
        cell.border = allBorders
        if (colNum === 9 || colNum === 10 || colNum === 15) cell.numFmt = '"$"#,##0'
        if ([1, 12, 13].includes(colNum)) cell.alignment = { horizontal: 'center' }
        else if ([9, 10, 11, 15].includes(colNum)) cell.alignment = { horizontal: 'right' }
      })

      // ═══════════════════════════════════════════════════════════════
      // HOJA 3 — ALERTAS DE STOCK
      // ═══════════════════════════════════════════════════════════════
      const alertProducts = allProducts.filter(p => p.stock === 0 || p.stock <= p.reorderPoint)
      if (alertProducts.length > 0) {
        const ws3 = workbook.addWorksheet('⚠ Alertas Stock', {
          properties: { tabColor: { argb: 'FFDC2626' } },
          views: [{ state: 'frozen', xSplit: 0, ySplit: 2 }],
        })
        ws3.columns = [
          { width: 5 }, { width: 14 }, { width: 36 }, { width: 18 }, { width: 14 },
          { width: 12 }, { width: 14 }, { width: 16 }, { width: 20 }, { width: 14 },
        ]

        ws3.mergeCells('A1:J1')
        const alertTitle = ws3.getCell('A1')
        alertTitle.value = `⚠️  PRODUCTOS CON ALERTA DE STOCK — ${alertProducts.length} productos`
        alertTitle.font = { bold: true, size: 13, color: { argb: 'FFFFFFFF' } }
        alertTitle.alignment = { horizontal: 'center', vertical: 'middle' }
        alertTitle.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFDC2626' } }
        ws3.getRow(1).height = 28

        const alertHeaders = ['#', 'SKU', 'Nombre', 'Categoría', 'Stock Actual', 'Punto Reorden', 'Faltante', 'Precio Costo', 'Proveedor', 'Estado']
        const alertHRow = ws3.getRow(2)
        alertHRow.height = 20
        alertHeaders.forEach((h, i) => {
          const cell = alertHRow.getCell(i + 1)
          cell.value = h
          cell.font = headerFont
          cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF334155' } }
          cell.alignment = { horizontal: 'center', vertical: 'middle' }
          cell.border = allBorders
        })

        alertProducts.forEach((p, i) => {
          const status = getStockStatus(p)
          const faltante = Math.max(0, p.reorderPoint - p.stock)
          const isAgotado = status === 'agotado'
          const rowBg = isAgotado ? RED_LIGHT : AMBER_LIGHT
          const textColor = isAgotado ? RED : AMBER

          const row = ws3.addRow([
            i + 1,
            p.sku,
            p.name,
            getCategoryName(p.category),
            p.stock,
            p.reorderPoint,
            faltante,
            p.purchasePrice,
            p.supplier ?? '',
            isAgotado ? '🔴 Agotado' : '🟡 Bajo stock',
          ])
          row.height = 18
          row.eachCell({ includeEmpty: true }, (cell, colNum) => {
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF' + rowBg } }
            cell.border = allBorders
            if (colNum === 10) cell.font = { bold: true, color: { argb: 'FF' + textColor } }
            if (colNum === 8) cell.numFmt = '"$"#,##0'
            if ([1, 5, 6, 7].includes(colNum)) cell.alignment = { horizontal: 'center' }
            if (colNum === 8) cell.alignment = { horizontal: 'right' }
          })
        })
      }

      // ── DOWNLOAD ────────────────────────────────────────────────────────────
      const buffer = await workbook.xlsx.writeBuffer()
      const blob = new Blob([buffer], {
        type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      })
      const url = URL.createObjectURL(blob)
      const a = document.createElement('a')
      a.href = url
      a.download = `Informe_Inventario_${dateFile}.xlsx`
      a.click()
      URL.revokeObjectURL(url)
      toast.success('Informe Excel generado correctamente')
    } catch (err) {
      console.error(err)
      toast.error('Error al generar el informe Excel')
    } finally {
      setIsExportingExcel(false)
    }
  }

  const [categoryForm, setCategoryForm] = useState({ name: '', description: '' })
  const [editingCategory, setEditingCategory] = useState<{ id: string; name: string; description: string } | null>(null)
  const [deletingCategoryId, setDeletingCategoryId] = useState<string | null>(null)

  // Derived: set of hidden category IDs for fast lookup
  const hiddenCategoryIds = new Set(categories.filter(c => c.isHidden).map(c => c.id))
  const [sedeForm, setSedeForm] = useState({ name: '', address: '' })
  const [editingSede, setEditingSede] = useState<Sede | null>(null)
  const [highlightedProduct, setHighlightedProduct] = useState<string | null>(null)

  useEffect(() => {
    fetchProducts()
    fetchCategories()
    fetchSedes()
  }, [fetchProducts, fetchCategories, fetchSedes])

  // Apply filters from notification navigation
  useEffect(() => {
    if (inventoryStockFilter) {
      setStockFilter(inventoryStockFilter)
    }
    if (inventorySearchQuery) {
      setSearch(inventorySearchQuery)
      // Find the product to highlight and scroll to it
      const product = products.find(p => p.name === inventorySearchQuery)
      if (product) {
        setHighlightedProduct(product.id)
        // Scroll to the product row after render
        setTimeout(() => {
          const el = document.getElementById(`product-${product.id}`)
          el?.scrollIntoView({ behavior: 'smooth', block: 'center' })
        }, 100)
        // Remove highlight after 3 seconds
        setTimeout(() => setHighlightedProduct(null), 3000)
      }
    }
    if (inventoryStockFilter || inventorySearchQuery) {
      clearInventoryFilters()
    }
  }, [inventoryStockFilter, inventorySearchQuery, clearInventoryFilters, products])

  const getCategoryName = (categoryId: string) => {
    const cat = categories.find(c => c.id === categoryId)
    return cat ? cat.name : categoryId
  }

  // Derive used types and categories from products
  const usedTypes = new Set(products.map(p => p.productType).filter(Boolean))
  const usedCategories = new Set(products.map(p => p.category).filter(Boolean))

  const normalizedSearch = search.trim().toLowerCase()
  const getSearchRank = (product: Product, q: string) => {
    if (!q) return 0
    const articulo = product.articulo?.toLowerCase() || ''
    const name = product.name.toLowerCase()
    const sku = product.sku.toLowerCase()
    const barcode = product.barcode?.toLowerCase() || ''
    const brand = product.brand?.toLowerCase() || ''

    if (articulo.includes(q)) return 0
    if (name.includes(q)) return 1
    if (sku.includes(q)) return 2
    if (barcode.includes(q)) return 3
    if (brand.includes(q)) return 4
    return 5
  }

  // Filter products (hidden categories are fully excluded)
  const filteredProducts = products.filter(product => {
    if (hiddenCategoryIds.has(product.category)) return false

    const matchesSearch =
      product.name.toLowerCase().includes(normalizedSearch) ||
      (product.articulo && product.articulo.toLowerCase().includes(normalizedSearch)) ||
      product.sku.toLowerCase().includes(normalizedSearch) ||
      (product.brand && product.brand.toLowerCase().includes(normalizedSearch)) ||
      (product.barcode && product.barcode.toLowerCase().includes(normalizedSearch))

    const matchesCategory = categoryFilter === 'all' || product.category === categoryFilter
    const matchesType = typeFilter === 'all' || product.productType === typeFilter
    const matchesSede = activeSede === 'all' || product.sedeId === activeSede || !product.sedeId

    const status = getStockStatus(product)
    const matchesStock = stockFilter === 'all' ||
      (stockFilter === 'suficiente' && status === 'suficiente') ||
      (stockFilter === 'bajo' && status === 'bajo') ||
      (stockFilter === 'agotado' && status === 'agotado')

    return matchesSearch && matchesCategory && matchesStock && matchesType && matchesSede
  })

  const rankedProducts = normalizedSearch
    ? [...filteredProducts].sort((a, b) => {
        const rankDiff = getSearchRank(a, normalizedSearch) - getSearchRank(b, normalizedSearch)
        if (rankDiff !== 0) return rankDiff
        return a.name.localeCompare(b.name)
      })
    : filteredProducts

  const totalPages = Math.ceil(rankedProducts.length / ITEMS_PER_PAGE)
  const paginatedProducts = rankedProducts.slice(
    (currentPage - 1) * ITEMS_PER_PAGE,
    currentPage * ITEMS_PER_PAGE
  )

  // Reset to first page when filters change
  useEffect(() => {
    setCurrentPage(1)
  }, [search, categoryFilter, stockFilter, typeFilter, activeSede])

  const activeSedeObj = sedes.find(s => s.id === activeSede)

  const handleEdit = (product: Product) => {
    setSelectedProduct(product)
    setIsEditDialogOpen(true)
  }

  const handleDelete = (product: Product) => {
    setSelectedProduct(product)
    setIsDeleteDialogOpen(true)
  }

  const confirmDelete = async () => {
    if (selectedProduct) {
      const result = await deleteProduct(selectedProduct.id)
      if (result.success) {
        setIsDeleteDialogOpen(false)
        setSelectedProduct(null)
      } else {
        toast.error(result.error || 'Error al eliminar producto')
      }
    }
  }

  const getProductTypeInfo = (type: ProductType) => {
    return PRODUCT_TYPES[type] || PRODUCT_TYPES.general
  }

  return (
    <div className="space-y-6 lg:space-y-8">
      {/* Sticky sede badge — only shows when there are 2+ sedes */}
      {sedes.length >= 2 && (
        <div className="sticky top-0 z-20 -mx-4 px-4 py-2 bg-background/95 backdrop-blur border-b border-border flex items-center gap-3 flex-wrap">
          <MapPin className="h-4 w-4 text-primary shrink-0" />
          <span className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">Sede:</span>
          <div className="flex gap-2 flex-wrap">
            <button
              onClick={() => setActiveSede('all')}
              className={`px-3 py-1 rounded-full text-xs font-medium transition-colors ${activeSede === 'all' ? 'bg-primary text-primary-foreground' : 'bg-secondary text-muted-foreground hover:bg-secondary/80'}`}
            >
              Todas
            </button>
            {sedes.map(s => (
              <button
                key={s.id}
                onClick={() => setActiveSede(s.id)}
                className={`px-3 py-1 rounded-full text-xs font-medium transition-colors ${activeSede === s.id ? 'bg-primary text-primary-foreground' : 'bg-secondary text-muted-foreground hover:bg-secondary/80'}`}
              >
                {s.name}
              </button>
            ))}
          </div>
          <button
            onClick={() => { setEditingSede(null); setSedeForm({ name: '', address: '' }); setIsSedeDialogOpen(true) }}
            className="ml-auto flex items-center gap-1 text-xs text-muted-foreground hover:text-foreground transition-colors"
          >
            <Settings2 className="h-3 w-3" />
            Gestionar sedes
          </button>
        </div>
      )}

      {/* Header */}
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h2 className="text-lg sm:text-xl lg:text-2xl font-semibold text-foreground">Productos</h2>
          <p className="text-sm lg:text-base text-muted-foreground">
            {filteredProducts.length} de {products.length} productos
            {activeSedeObj && <span className="ml-2 text-primary">— Sede: {activeSedeObj.name}</span>}
          </p>
        </div>
        <div className="flex gap-2 flex-wrap">
          <Button variant="outline" onClick={() => { setEditingSede(null); setSedeForm({ name: '', address: '' }); setIsSedeDialogOpen(true) }} className="gap-2 h-10 lg:h-11 text-sm lg:text-base">
            <MapPin className="h-4 w-4 lg:h-5 lg:w-5" />
            Sedes
          </Button>
          <Button variant="outline" onClick={() => setIsCategoryDialogOpen(true)} className="gap-2 h-10 lg:h-11 text-sm lg:text-base">
            <Tags className="h-4 w-4 lg:h-5 lg:w-5" />
            Crear Categoria
          </Button>
          <Button variant="outline" onClick={() => setIsBulkUploadOpen(true)} className="gap-2 h-10 lg:h-11 text-sm lg:text-base">
            <Upload className="h-4 w-4 lg:h-5 lg:w-5" />
            Importar CSV
          </Button>
          <Button variant="outline" onClick={handleExportCsv} disabled={isExporting} className="gap-2 h-10 lg:h-11 text-sm lg:text-base">
            <FileDown className="h-4 w-4 lg:h-5 lg:w-5" />
            {isExporting ? 'Exportando...' : 'Exportar CSV'}
          </Button>
          <Button variant="outline" onClick={handleExportExcel} disabled={isExportingExcel} className="gap-2 h-10 lg:h-11 text-sm lg:text-base border-green-600 text-green-700 hover:bg-green-50 dark:border-green-500 dark:text-green-400 dark:hover:bg-green-950/30">
            <FileSpreadsheet className="h-4 w-4 lg:h-5 lg:w-5" />
            {isExportingExcel ? 'Generando...' : 'Exportar Excel'}
          </Button>
          <Button onClick={() => setIsAddDialogOpen(true)} className="gap-2 h-10 lg:h-11 text-sm lg:text-base">
            <Plus className="h-4 w-4 lg:h-5 lg:w-5" />
            Agregar Producto
          </Button>
        </div>
      </div>

      {/* Filters */}
      <Card className="border-border bg-card">
        <CardContent className="p-4 lg:p-6">
          <div className="flex flex-col gap-4 md:flex-row md:items-center">
            <div className="relative flex-1">
              <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
              <Input
                placeholder="Buscar por nombre, SKU, marca o codigo..."
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                className="pl-9 bg-secondary border-none h-10 lg:h-11"
              />
            </div>
            <div className="flex gap-2 sm:gap-3 flex-wrap">
              <Select value={typeFilter} onValueChange={setTypeFilter}>
                <SelectTrigger className="w-[130px] sm:w-[160px] bg-secondary border-none h-10 lg:h-11">
                  <SelectValue placeholder="Tipo" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Todos los tipos</SelectItem>
                  {Object.values(PRODUCT_TYPES).filter(t => usedTypes.has(t.id)).map((t) => (
                    <SelectItem key={t.id} value={t.id}>
                      {t.icon} {t.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
              <Select value={categoryFilter} onValueChange={setCategoryFilter}>
                <SelectTrigger className="w-[130px] sm:w-[160px] bg-secondary border-none h-10 lg:h-11">
                  <Filter className="mr-2 h-4 w-4 hidden sm:block" />
                  <SelectValue placeholder="Categoria" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Todas</SelectItem>
                  {categories.filter(cat => usedCategories.has(cat.id) && !cat.isHidden).map((cat) => (
                    <SelectItem key={cat.id} value={cat.id}>
                      {cat.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
              <Select value={stockFilter} onValueChange={setStockFilter}>
                <SelectTrigger className="w-[110px] sm:w-[140px] bg-secondary border-none h-10 lg:h-11">
                  <SelectValue placeholder="Stock" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Todo</SelectItem>
                  <SelectItem value="suficiente">Suficiente</SelectItem>
                  <SelectItem value="bajo">Reabastecimiento</SelectItem>
                  <SelectItem value="agotado">Agotado</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Products Table */}
      <Card className="border-border bg-card">
        <CardContent className="p-0 overflow-x-auto">
          <Table className="min-w-[800px]">
            <TableHeader>
              <TableRow className="border-border hover:bg-transparent">
                <TableHead className="text-muted-foreground text-sm lg:text-base">Producto</TableHead>
                <TableHead className="text-muted-foreground text-sm lg:text-base">SKU</TableHead>
                <TableHead className="text-muted-foreground text-sm lg:text-base">Tipo</TableHead>
                <TableHead className="text-muted-foreground text-sm lg:text-base">Categoria</TableHead>
                {sedes.length >= 2 && <TableHead className="text-muted-foreground text-sm lg:text-base">Sede</TableHead>}
                <TableHead className="text-muted-foreground text-sm lg:text-base text-right">Precio</TableHead>
                <TableHead className="text-muted-foreground text-sm lg:text-base text-center">Stock</TableHead>
                <TableHead className="text-muted-foreground text-sm lg:text-base text-right">Acciones</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {filteredProducts.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={sedes.length >= 2 ? 8 : 7} className="h-24 text-center">
                    <div className="flex flex-col items-center gap-2">
                      <Package className="h-8 w-8 lg:h-10 lg:w-10 text-muted-foreground" />
                      <p className="text-sm lg:text-base text-muted-foreground">No se encontraron productos</p>
                    </div>
                  </TableCell>
                </TableRow>
              ) : (
                paginatedProducts.map((product) => {
                  const status = getStockStatus(product)
                  const typeInfo = getProductTypeInfo(product.productType)
                  return (
                    <TableRow
                      key={product.id}
                      id={`product-${product.id}`}
                      className={`border-border transition-colors duration-1000 ${
                        highlightedProduct === product.id ? 'bg-primary/15 ring-1 ring-primary/30' : ''
                      }`}
                    >
                      <TableCell>
                        <div className="flex items-center gap-3">
                          <div className="flex h-10 w-10 lg:h-12 lg:w-12 items-center justify-center rounded-lg bg-secondary text-lg">
                            {typeInfo.icon}
                          </div>
                          <div>
                            <p className="font-medium text-sm lg:text-base text-foreground">{product.name}</p>
                            {product.articulo && (
                              <p className="text-xs text-muted-foreground/70 italic">Inv: {product.articulo}</p>
                            )}
                            <p className="text-xs lg:text-sm text-muted-foreground">
                              {product.brand || ''}{product.brand && product.color ? ' | ' : ''}{product.color || ''}
                              {product.size ? ` | ${product.size}` : ''}
                            </p>
                          </div>
                        </div>
                      </TableCell>
                      <TableCell className="text-muted-foreground font-mono text-xs lg:text-sm">
                        {product.sku}
                      </TableCell>
                      <TableCell>
                        <Badge variant="secondary" className="bg-secondary text-muted-foreground text-xs">
                          {typeInfo.icon} {typeInfo.name}
                        </Badge>
                      </TableCell>
                      <TableCell>
                        <Badge variant="secondary" className="bg-secondary text-muted-foreground text-xs lg:text-sm">
                          {getCategoryName(product.category)}
                        </Badge>
                      </TableCell>
                      {sedes.length >= 2 && (
                        <TableCell>
                          {product.sedeId ? (
                            <Badge variant="outline" className="text-xs border-primary/40 text-primary/80">
                              <MapPin className="h-2.5 w-2.5 mr-1" />
                              {sedes.find(s => s.id === product.sedeId)?.name || '—'}
                            </Badge>
                          ) : (
                            <span className="text-xs text-muted-foreground">Todas</span>
                          )}
                        </TableCell>
                      )}
                      <TableCell className="text-right">
                        <div>
                          <p className="font-medium text-sm lg:text-base text-foreground">
                            {formatCOP(product.salePrice)}
                          </p>
                          <p className="text-xs lg:text-sm text-muted-foreground">
                            Costo: {formatCOP(product.purchasePrice)}
                          </p>
                        </div>
                      </TableCell>
                      <TableCell className="text-center">
                        <div className="flex flex-col items-center justify-center gap-1">
                          <div className="flex items-center justify-center gap-2">
                            {status === 'suficiente' && <CheckCircle2 className="h-4 w-4 text-emerald-600" />}
                            {status === 'bajo' && <AlertTriangle className="h-4 w-4 text-amber-600" />}
                            {status === 'agotado' && <XCircle className="h-4 w-4 text-red-600" />}
                            <span className={`h-2 w-2 lg:h-2.5 lg:w-2.5 rounded-full ${
                              status === 'suficiente' ? 'bg-emerald-500' :
                              status === 'bajo' ? 'bg-amber-500' : 'bg-red-500'
                            }`} />
                            <span className={`font-medium text-sm lg:text-base ${
                              status === 'suficiente' ? 'text-emerald-700' :
                              status === 'bajo' ? 'text-amber-700' : 'text-red-700'
                            }`}>
                              {product.stock}
                            </span>
                          </div>
                          {status === 'bajo' && (
                            <Badge variant="secondary" className="bg-amber-50 text-amber-700 border border-amber-200 text-[10px] px-1.5 py-0">
                              Reabastecimiento
                            </Badge>
                          )}
                        </div>
                      </TableCell>
                      <TableCell className="text-right">
                        <div className="flex items-center justify-end gap-2">
                          <Button
                            variant="ghost"
                            size="icon"
                            onClick={() => handleEdit(product)}
                            className="h-8 w-8 lg:h-9 lg:w-9"
                          >
                            <Edit2 className="h-4 w-4" />
                          </Button>
                          <Button
                            variant="ghost"
                            size="icon"
                            onClick={() => handleDelete(product)}
                            className="h-8 w-8 lg:h-9 lg:w-9 text-destructive hover:text-destructive"
                          >
                            <Trash2 className="h-4 w-4" />
                          </Button>
                        </div>
                      </TableCell>
                    </TableRow>
                  )
                })
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      {/* Pagination */}
      {totalPages > 1 && (
        <div className="flex items-center justify-between">
          <p className="text-sm text-muted-foreground">
            Página {currentPage} de {totalPages} ({filteredProducts.length} productos)
          </p>
          <div className="flex items-center gap-2">
            <Button
              variant="outline"
              size="icon"
              className="h-8 w-8"
              onClick={() => setCurrentPage(p => Math.max(1, p - 1))}
              disabled={currentPage === 1}
            >
              <ChevronLeft className="h-4 w-4" />
            </Button>
            {Array.from({ length: Math.min(5, totalPages) }, (_, i) => {
              let page: number
              if (totalPages <= 5) {
                page = i + 1
              } else if (currentPage <= 3) {
                page = i + 1
              } else if (currentPage >= totalPages - 2) {
                page = totalPages - 4 + i
              } else {
                page = currentPage - 2 + i
              }
              return (
                <Button
                  key={page}
                  variant={currentPage === page ? 'default' : 'outline'}
                  size="icon"
                  className="h-8 w-8 text-sm"
                  onClick={() => setCurrentPage(page)}
                >
                  {page}
                </Button>
              )
            })}
            <Button
              variant="outline"
              size="icon"
              className="h-8 w-8"
              onClick={() => setCurrentPage(p => Math.min(totalPages, p + 1))}
              disabled={currentPage === totalPages}
            >
              <ChevronRight className="h-4 w-4" />
            </Button>
          </div>
        </div>
      )}

      {/* Add Product Dialog */}
      <ProductFormDialog
        open={isAddDialogOpen}
        onOpenChange={setIsAddDialogOpen}
        onSubmit={async (data) => {
          const result = await addProduct(data)
          if (result.success) {
            setIsAddDialogOpen(false)
            toast.success('Producto creado exitosamente')
          } else {
            toast.error(result.error || 'Error al crear producto')
            console.error('Error creando producto:', result.error, 'Datos enviados:', data)
          }
        }}
        title="Agregar Producto"
        description="Complete los datos del nuevo producto"
        sedes={sedes}
        defaultSedeId={activeSede !== 'all' ? activeSede : undefined}
      />

      {/* Edit Product Dialog */}
      {selectedProduct && (
        <ProductFormDialog
          open={isEditDialogOpen}
          onOpenChange={setIsEditDialogOpen}
          onSubmit={async (data) => {
            const result = await updateProduct(selectedProduct.id, data)
            if (result.success) {
              setIsEditDialogOpen(false)
              setSelectedProduct(null)
              toast.success('Producto actualizado exitosamente')
            } else {
              toast.error(result.error || 'Error al actualizar producto')
            }
          }}
          title="Editar Producto"
          description="Modifique los datos del producto"
          initialData={selectedProduct}
          sedes={sedes}
        />
      )}

      {/* Delete Confirmation Dialog */}
      <Dialog open={isDeleteDialogOpen} onOpenChange={setIsDeleteDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Eliminar Producto</DialogTitle>
            <DialogDescription>
              Esta seguro que desea eliminar &quot;{selectedProduct?.name}&quot;? Esta accion no se puede deshacer.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setIsDeleteDialogOpen(false)}>
              Cancelar
            </Button>
            <Button variant="destructive" onClick={confirmDelete}>
              Eliminar
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Category Management Dialog */}
      <Dialog open={isCategoryDialogOpen} onOpenChange={(open) => {
        setIsCategoryDialogOpen(open)
        if (!open) { setEditingCategory(null); setDeletingCategoryId(null); setCategoryForm({ name: '', description: '' }) }
      }}>
        <DialogContent className="max-w-lg">
          <DialogHeader>
            <DialogTitle>Gestionar Categorías</DialogTitle>
            <DialogDescription>Agrega, edita, oculta o elimina categorías de productos.</DialogDescription>
          </DialogHeader>

          <div className="space-y-4 py-2">
            {/* Category list */}
            <div className="border border-border rounded-lg overflow-hidden">
              {categories.length === 0 && (
                <p className="text-sm text-muted-foreground text-center py-6">No hay categorías aún.</p>
              )}
              {categories.map((cat, idx) => (
                <div
                  key={cat.id}
                  className={`flex items-center gap-2 px-3 py-2.5 text-sm border-b border-border/50 last:border-b-0 ${cat.isHidden ? 'bg-muted/40 opacity-60' : 'bg-card'}`}
                >
                  {/* Edit inline form or display */}
                  {editingCategory?.id === cat.id ? (
                    <form
                      className="flex flex-1 items-center gap-2"
                      onSubmit={async (e) => {
                        e.preventDefault()
                        if (!editingCategory.name.trim()) return
                        const result = await updateCategory(cat.id, {
                          name: editingCategory.name,
                          description: editingCategory.description || undefined,
                        })
                        if (result.success) {
                          toast.success('Categoría actualizada')
                          setEditingCategory(null)
                        } else {
                          toast.error(result.error || 'Error al actualizar')
                        }
                      }}
                    >
                      <Input
                        autoFocus
                        value={editingCategory.name}
                        onChange={(e) => setEditingCategory({ ...editingCategory, name: e.target.value })}
                        className="h-7 text-xs flex-1"
                        placeholder="Nombre"
                      />
                      <Input
                        value={editingCategory.description}
                        onChange={(e) => setEditingCategory({ ...editingCategory, description: e.target.value })}
                        className="h-7 text-xs w-32"
                        placeholder="Descripción"
                      />
                      <Button type="submit" size="sm" className="h-7 px-2 text-xs">Guardar</Button>
                      <Button type="button" variant="ghost" size="sm" className="h-7 px-2 text-xs" onClick={() => setEditingCategory(null)}>✕</Button>
                    </form>
                  ) : (
                    <>
                      <span className="flex-1 font-medium truncate">
                        {cat.name}
                        {cat.isHidden && <span className="ml-2 text-[10px] text-muted-foreground font-normal">(oculta)</span>}
                      </span>
                      {cat.description && (
                        <span className="text-xs text-muted-foreground truncate max-w-[120px]">{cat.description}</span>
                      )}
                      <span className="text-xs text-muted-foreground ml-1">
                        {products.filter(p => p.category === cat.id).length} items
                      </span>

                      {/* Edit */}
                      <button
                        onClick={() => setEditingCategory({ id: cat.id, name: cat.name, description: cat.description || '' })}
                        className="p-1 rounded hover:bg-muted text-muted-foreground hover:text-foreground transition-colors"
                        title="Editar"
                      >
                        <Pencil className="h-3.5 w-3.5" />
                      </button>

                      {/* Toggle hide/show */}
                      <button
                        onClick={async () => {
                          const result = await updateCategory(cat.id, { isHidden: !cat.isHidden })
                          if (result.success) {
                            toast.success(cat.isHidden ? `"${cat.name}" ahora es visible` : `"${cat.name}" oculta`)
                          } else {
                            toast.error(result.error || 'Error')
                          }
                        }}
                        className={`p-1 rounded transition-colors ${cat.isHidden ? 'text-amber-500 hover:text-amber-600 hover:bg-amber-50 dark:hover:bg-amber-950/20' : 'text-muted-foreground hover:text-foreground hover:bg-muted'}`}
                        title={cat.isHidden ? 'Mostrar categoría' : 'Ocultar categoría'}
                      >
                        {cat.isHidden ? <EyeOff className="h-3.5 w-3.5" /> : <Eye className="h-3.5 w-3.5" />}
                      </button>

                      {/* Delete */}
                      {deletingCategoryId === cat.id ? (
                        <div className="flex items-center gap-1">
                          <span className="text-[10px] text-red-500">¿Eliminar?</span>
                          <button
                            onClick={async () => {
                              const result = await deleteCategory(cat.id)
                              if (result.success) {
                                toast.success('Categoría eliminada')
                                setDeletingCategoryId(null)
                              } else {
                                toast.error(result.error || 'No se puede eliminar')
                                setDeletingCategoryId(null)
                              }
                            }}
                            className="text-[10px] px-1.5 py-0.5 bg-red-500 text-white rounded hover:bg-red-600"
                          >Sí</button>
                          <button
                            onClick={() => setDeletingCategoryId(null)}
                            className="text-[10px] px-1.5 py-0.5 bg-muted rounded hover:bg-muted-foreground/20"
                          >No</button>
                        </div>
                      ) : (
                        <button
                          onClick={() => setDeletingCategoryId(cat.id)}
                          className="p-1 rounded hover:bg-red-50 dark:hover:bg-red-950/20 text-muted-foreground hover:text-red-500 transition-colors"
                          title="Eliminar"
                        >
                          <Trash2 className="h-3.5 w-3.5" />
                        </button>
                      )}
                    </>
                  )}
                </div>
              ))}
            </div>

            {/* Add new category form */}
            <form
              onSubmit={async (e) => {
                e.preventDefault()
                if (!categoryForm.name.trim()) return
                const id = categoryForm.name.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '')
                const result = await addCategory({ id, name: categoryForm.name, description: categoryForm.description || undefined })
                if (result.success) {
                  toast.success('Categoría creada')
                  setCategoryForm({ name: '', description: '' })
                } else {
                  toast.error(result.error || 'Error al crear')
                }
              }}
              className="border border-dashed border-border rounded-lg p-3 space-y-2"
            >
              <p className="text-xs font-semibold text-muted-foreground uppercase tracking-wide">Nueva categoría</p>
              <div className="flex gap-2">
                <Input
                  value={categoryForm.name}
                  onChange={(e) => setCategoryForm({ ...categoryForm, name: e.target.value })}
                  placeholder="Nombre de la categoría"
                  className="h-8 text-sm flex-1"
                  required
                />
                <Input
                  value={categoryForm.description}
                  onChange={(e) => setCategoryForm({ ...categoryForm, description: e.target.value })}
                  placeholder="Descripción (opcional)"
                  className="h-8 text-sm w-36"
                />
                <Button type="submit" size="sm" className="h-8 gap-1.5 px-3">
                  <Plus className="h-3.5 w-3.5" />
                  Agregar
                </Button>
              </div>
            </form>
          </div>

          <DialogFooter>
            <Button variant="outline" onClick={() => setIsCategoryDialogOpen(false)}>Cerrar</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Sede Management Dialog */}
      <Dialog open={isSedeDialogOpen} onOpenChange={setIsSedeDialogOpen}>
        <DialogContent className="max-w-md">
          <DialogHeader>
            <DialogTitle>Gestionar Sedes</DialogTitle>
            <DialogDescription>Agrega o edita las sucursales de tu negocio</DialogDescription>
          </DialogHeader>
          <div className="space-y-4 py-2">
            {/* Existing sedes list */}
            {sedes.length > 0 && (
              <div className="space-y-2">
                <Label className="text-xs uppercase text-muted-foreground tracking-wider">Sedes existentes</Label>
                {sedes.map(s => (
                  <div key={s.id} className="flex items-center justify-between gap-2 p-2 rounded-lg border border-border bg-secondary/30">
                    <div>
                      <p className="font-medium text-sm">{s.name}</p>
                      {s.address && <p className="text-xs text-muted-foreground">{s.address}</p>}
                    </div>
                    <div className="flex gap-1">
                      <Button variant="ghost" size="icon" className="h-7 w-7" onClick={() => {
                        setEditingSede(s)
                        setSedeForm({ name: s.name, address: s.address || '' })
                      }}>
                        <Edit2 className="h-3 w-3" />
                      </Button>
                      <Button variant="ghost" size="icon" className="h-7 w-7 text-destructive hover:text-destructive" onClick={async () => {
                        await deleteSede(s.id)
                        if (activeSede === s.id) setActiveSede('all')
                        toast.success('Sede eliminada')
                      }}>
                        <Trash2 className="h-3 w-3" />
                      </Button>
                    </div>
                  </div>
                ))}
              </div>
            )}
            {/* Add / Edit form */}
            <form onSubmit={async (e) => {
              e.preventDefault()
              if (!sedeForm.name.trim()) return
              if (editingSede) {
                const result = await updateSede(editingSede.id, { name: sedeForm.name.trim(), address: sedeForm.address || undefined })
                if (result.success) { setEditingSede(null); setSedeForm({ name: '', address: '' }); toast.success('Sede actualizada') }
                else toast.error(result.error || 'Error al actualizar')
              } else {
                const result = await addSede({ name: sedeForm.name.trim(), address: sedeForm.address || undefined })
                if (result.success) { setSedeForm({ name: '', address: '' }); toast.success('Sede creada') }
                else toast.error(result.error || 'Error al crear')
              }
            }} className="space-y-3 border-t border-border pt-4">
              <Label className="text-xs uppercase text-muted-foreground tracking-wider">
                {editingSede ? `Editando: ${editingSede.name}` : 'Nueva sede'}
              </Label>
              <Input
                placeholder="Nombre de la sede (ej: Sede Centro)"
                value={sedeForm.name}
                onChange={e => setSedeForm(p => ({ ...p, name: e.target.value }))}
                required
              />
              <Input
                placeholder="Dirección (opcional)"
                value={sedeForm.address}
                onChange={e => setSedeForm(p => ({ ...p, address: e.target.value }))}
              />
              <div className="flex gap-2">
                {editingSede && (
                  <Button type="button" variant="outline" onClick={() => { setEditingSede(null); setSedeForm({ name: '', address: '' }) }} className="flex-1">
                    Cancelar
                  </Button>
                )}
                <Button type="submit" className="flex-1">
                  {editingSede ? 'Guardar cambios' : 'Agregar sede'}
                </Button>
              </div>
            </form>
          </div>
        </DialogContent>
      </Dialog>

      {/* Bulk Upload Dialog */}
      <BulkUploadDialog
        open={isBulkUploadOpen}
        onOpenChange={setIsBulkUploadOpen}
      />
    </div>
  )
}

interface ProductFormDialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  onSubmit: (data: any) => void
  title: string
  description: string
  initialData?: Product
  sedes?: Sede[]
  defaultSedeId?: string
}

function ProductFormDialog({
  open,
  onOpenChange,
  onSubmit,
  title,
  description,
  initialData,
  sedes = [],
  defaultSedeId,
}: ProductFormDialogProps) {
  const { categories } = useStore()
  const [showScanner, setShowScanner] = useState(false)
  const [showRemoteScanner, setShowRemoteScanner] = useState(false)
  const [formData, setFormData] = useState<Record<string, any>>(() => getInitialFormData(initialData, categories, defaultSedeId))

  // Reset form and scanner state when dialog opens/closes or initialData changes
  useEffect(() => {
    if (open) {
      setFormData(getInitialFormData(initialData, categories, defaultSedeId))
      setShowScanner(false)
      setShowRemoteScanner(false)
    }
  }, [open, initialData, categories, defaultSedeId])

  const productType = (formData.productType || 'general') as ProductType
  const typeFields = getFieldsForProductType(productType)

  const updateField = (name: string, value: any) => {
    setFormData(prev => ({ ...prev, [name]: value }))
  }

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    // Clean up empty/whitespace-only strings to not send them
    const cleaned: Record<string, any> = {}
    for (const [key, value] of Object.entries(formData)) {
      if (value === '' || value === undefined || value === null) continue
      if (typeof value === 'string' && value.trim() === '') continue
      cleaned[key] = typeof value === 'string' ? value.trim() : value
    }
    onSubmit(cleaned)
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>{title}</DialogTitle>
          <DialogDescription>{description}</DialogDescription>
        </DialogHeader>
        <form onSubmit={handleSubmit}>
          <div className="grid gap-4 py-4">
            {/* Product Type Selector */}
            <div className="space-y-2">
              <Label>Tipo de Producto</Label>
              <div className="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-5 gap-2">
                {Object.values(PRODUCT_TYPES).map((type) => (
                  <button
                    key={type.id}
                    type="button"
                    onClick={() => updateField('productType', type.id)}
                    className={`flex flex-col items-center gap-1 p-2 rounded-lg border text-xs transition-colors ${
                      productType === type.id
                        ? 'border-primary bg-primary/10 text-primary'
                        : 'border-border hover:border-muted-foreground/50'
                    }`}
                  >
                    <span className="text-lg">{type.icon}</span>
                    <span className="truncate w-full text-center">{type.name}</span>
                  </button>
                ))}
              </div>
            </div>

            {/* Common fields - always visible */}
            <div className="space-y-2">
              <Label htmlFor="name">Nombre en tienda *</Label>
              <Input
                id="name"
                value={formData.name || ''}
                onChange={(e) => updateField('name', e.target.value)}
                placeholder="Nombre visible para clientes"
                required
              />
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="articulo">Artículo (inventario)</Label>
                <Input
                  id="articulo"
                  value={formData.articulo || ''}
                  onChange={(e) => updateField('articulo', e.target.value)}
                  placeholder="Nombre interno de inventario"
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="category">Categoría *</Label>
                <Select
                  value={formData.category || ''}
                  onValueChange={(value) => updateField('category', value)}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Seleccionar" />
                  </SelectTrigger>
                  <SelectContent>
                    {categories.map((cat) => (
                      <SelectItem key={cat.id} value={cat.id}>
                        {cat.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="sku">SKU / Codigo *</Label>
                <Input
                  id="sku"
                  value={formData.sku || ''}
                  onChange={(e) => updateField('sku', e.target.value)}
                  required
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="barcode">Codigo de Barras</Label>
                <div className="flex gap-2">
                  <div className="flex-1 relative">
                    <Input
                      id="barcode"
                      value={formData.barcode || ''}
                      onChange={(e) => updateField('barcode', e.target.value)}
                      placeholder="Escanea o ingresa manualmente"
                      className={formData.barcode ? 'border-green-500' : ''}
                    />
                    {formData.barcode && (
                      <div className="absolute right-3 top-1/2 -translate-y-1/2 flex items-center gap-1">
                        <svg className="h-4 w-4 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                          <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                        </svg>
                      </div>
                    )}
                  </div>
                  <div className="flex gap-1">
                    <Button
                      type="button"
                      variant="outline"
                      size="icon"
                      onClick={() => setShowScanner(true)}
                      title="Escanear con cámara local (DroidCam)"
                    >
                      <ScanLine className="h-4 w-4" />
                    </Button>
                    <Button
                      type="button"
                      variant="outline"
                      size="icon"
                      onClick={() => setShowRemoteScanner(true)}
                      title="Escanear con cámara remota (QR)"
                    >
                      <Smartphone className="h-4 w-4" />
                    </Button>
                  </div>
                </div>
              </div>
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="purchasePrice">Precio de compra (COP)</Label>
                <div className="relative">
                  <span className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground text-sm">$</span>
                  <Input
                    id="purchasePrice"
                    type="number"
                    min="0"
                    step="0.01"
                    placeholder="50000"
                    value={formData.purchasePrice || ''}
                    onChange={(e) => updateField('purchasePrice', e.target.value === '' ? '' : parseFloat(e.target.value))}
                    className="pl-7"
                  />
                </div>
              </div>
              <div className="space-y-2">
                <Label htmlFor="salePrice">Precio de venta (COP)</Label>
                <div className="relative">
                  <span className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground text-sm">$</span>
                  <Input
                    id="salePrice"
                    type="number"
                    min="0"
                    step="0.01"
                    placeholder={formData.category === 'insumos' ? '0' : '249999'}
                    value={formData.salePrice || ''}
                    onChange={(e) => updateField('salePrice', e.target.value === '' ? '' : parseFloat(e.target.value))}
                    className="pl-7"
                  />
                </div>
              </div>
            </div>

            <div className="grid grid-cols-3 gap-4">
              <div className="space-y-2">
                <Label htmlFor="stock">Stock *</Label>
                <Input
                  id="stock"
                  type="number"
                  min="0"
                  placeholder="10"
                  value={formData.stock ?? ''}
                  onChange={(e) => updateField('stock', parseInt(e.target.value) || 0)}
                  required
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="reorderPoint">Punto de reorden *</Label>
                <Input
                  id="reorderPoint"
                  type="number"
                  min="0"
                  placeholder="5"
                  value={formData.reorderPoint ?? ''}
                  onChange={(e) => updateField('reorderPoint', parseInt(e.target.value) || 0)}
                  required
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="entryDate">Fecha de ingreso *</Label>
                <Input
                  id="entryDate"
                  type="date"
                  value={formData.entryDate || ''}
                  onChange={(e) => updateField('entryDate', e.target.value)}
                  required
                />
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="supplier">Proveedor</Label>
              <Input
                id="supplier"
                value={formData.supplier || ''}
                onChange={(e) => updateField('supplier', e.target.value)}
                placeholder="Nombre del proveedor"
              />
            </div>

            {/* Sede selector — only visible when there are sedes configured */}
            {sedes.length >= 1 && (
              <div className="space-y-2">
                <Label htmlFor="sedeId">Sede / Sucursal</Label>
                <Select
                  value={formData.sedeId || 'all'}
                  onValueChange={(val) => updateField('sedeId', val === 'all' ? '' : val)}
                >
                  <SelectTrigger>
                    <MapPin className="h-4 w-4 mr-2 text-muted-foreground" />
                    <SelectValue placeholder="Todas las sedes" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">Todas las sedes</SelectItem>
                    {sedes.map(s => (
                      <SelectItem key={s.id} value={s.id}>{s.name}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
                <p className="text-xs text-muted-foreground">Dejar en &quot;Todas&quot; para que aparezca en todas las sedes</p>
              </div>
            )}

            {/* ── Galería de imágenes (hasta 4) ───────────────── */}
            <div className="space-y-3">
              <Label>Imágenes del Producto (máx. 4)</Label>
              <p className="text-xs text-muted-foreground -mt-1">
                La primera imagen es la principal que se muestra en listas y tienda.
              </p>
              <div className="grid grid-cols-2 gap-3">
                {[0, 1, 2, 3].map((idx) => {
                  // Slot 0 = imageUrl (principal), slots 1-3 = images[1..3]
                  const imagesArr: string[] = Array.isArray(formData.images) ? formData.images : []
                  const slotValue = idx === 0
                    ? (formData.imageUrl || imagesArr[0] || '')
                    : (imagesArr[idx] || '')

                  const handleSlotChange = (url: string) => {
                    const next = [...Array(4)].map((_, i) => {
                      if (i === 0) return idx === 0 ? url : (formData.imageUrl || imagesArr[0] || '')
                      return i === idx ? url : (imagesArr[i] || '')
                    })
                    // Trim trailing empty slots
                    const trimmed = next.map(u => u.trim())
                    updateField('images', trimmed)
                    if (idx === 0) updateField('imageUrl', url)
                  }

                  return (
                    <div key={idx} className="rounded-lg border border-border p-2 bg-secondary/20">
                      <p className="text-xs font-medium text-muted-foreground mb-2">
                        {idx === 0 ? 'Imagen principal ★' : `Imagen ${idx + 1}`}
                      </p>
                      <CloudinaryUpload
                        value={slotValue}
                        onChange={handleSlotChange}
                        previewClassName="h-20 w-full object-cover rounded border"
                        accept="image/*,image/gif"
                      />
                    </div>
                  )
                })}
              </div>
            </div>

            {/* Dynamic type-specific fields */}
            {typeFields.length > 0 && (
              <>
                <div className="border-t border-border pt-4 mt-2">
                  <p className="text-sm font-medium text-muted-foreground mb-3">
                    {PRODUCT_TYPES[productType]?.icon} Campos de {PRODUCT_TYPES[productType]?.name}
                  </p>
                </div>
                <div className="grid grid-cols-2 gap-4">
                  {typeFields.map((field) => (
                    <DynamicField
                      key={field.name}
                      field={field}
                      value={formData[field.name]}
                      onChange={(value) => updateField(field.name, value)}
                    />
                  ))}
                </div>
              </>
            )}
          </div>
          <DialogFooter>
            <Button type="button" variant="outline" onClick={() => onOpenChange(false)}>
              Cancelar
            </Button>
            <Button type="submit">
              {initialData ? 'Guardar Cambios' : 'Agregar Producto'}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>

      {showScanner && (
        <BarcodeScanner
          onScan={(barcode) => setFormData(prev => ({ ...prev, barcode }))}
          onClose={() => setShowScanner(false)}
        />
      )}

      {showRemoteScanner && (
        <RemoteScanner
          onScan={(barcode) => {
            setFormData(prev => ({ ...prev, barcode }))
            setShowRemoteScanner(false)
          }}
          onClose={() => setShowRemoteScanner(false)}
        />
      )}
    </Dialog>
  )
}

function DynamicField({ field, value, onChange }: {
  field: { name: string; label: string; type: string; placeholder?: string; description?: string; min?: number; max?: number; step?: number; options?: Array<{ value: string; label: string }>; defaultValue?: any }
  value: any
  onChange: (value: any) => void
}) {
  const isFullWidth = field.type === 'textarea'

  const wrapper = (children: React.ReactNode) => (
    <div className={`space-y-2 ${isFullWidth ? 'col-span-2' : ''}`}>
      <Label htmlFor={field.name}>{field.label}</Label>
      {children}
      {field.description && <p className="text-xs text-muted-foreground">{field.description}</p>}
    </div>
  )

  if (field.type === 'select' && field.options) {
    return wrapper(
      <Select value={value || ''} onValueChange={onChange}>
        <SelectTrigger>
          <SelectValue placeholder="Seleccionar" />
        </SelectTrigger>
        <SelectContent>
          {field.options.map((opt) => (
            <SelectItem key={opt.value} value={opt.value}>{opt.label}</SelectItem>
          ))}
        </SelectContent>
      </Select>
    )
  }

  if (field.type === 'boolean') {
    return wrapper(
      <div className="flex items-center gap-2 pt-1">
        <Checkbox
          id={field.name}
          checked={!!value}
          onCheckedChange={(checked) => onChange(!!checked)}
        />
        <Label htmlFor={field.name} className="text-sm font-normal cursor-pointer">
          {value ? 'Si' : 'No'}
        </Label>
      </div>
    )
  }

  if (field.type === 'textarea') {
    return wrapper(
      <Textarea
        id={field.name}
        value={value || ''}
        onChange={(e) => onChange(e.target.value)}
        placeholder={field.placeholder}
        rows={2}
      />
    )
  }

  if (field.type === 'number') {
    return wrapper(
      <Input
        id={field.name}
        type="number"
        min={field.min}
        max={field.max}
        step={field.step}
        value={value ?? ''}
        onChange={(e) => onChange(e.target.value ? parseFloat(e.target.value) : '')}
        placeholder={field.placeholder}
      />
    )
  }

  if (field.type === 'date') {
    return wrapper(
      <Input
        id={field.name}
        type="date"
        value={value || ''}
        onChange={(e) => onChange(e.target.value)}
      />
    )
  }

  // Default: text
  return wrapper(
    <Input
      id={field.name}
      value={value || ''}
      onChange={(e) => onChange(e.target.value)}
      placeholder={field.placeholder}
    />
  )
}

function getInitialFormData(initialData: Product | undefined, categories: Array<{ id: string }>, defaultSedeId?: string) {
  if (initialData) {
    // Return all non-undefined properties from initialData
    const data: Record<string, any> = {}
    for (const [key, value] of Object.entries(initialData)) {
      if (key === 'id' || key === 'createdAt' || key === 'updatedAt' || key === 'stockStatus') continue
      if (value !== undefined && value !== null) {
        data[key] = value
      }
    }
    return data
  }

  return {
    name: '',
    category: categories[0]?.id || '',
    productType: 'general' as ProductType,
    purchasePrice: 0,
    salePrice: 0,
    sku: '',
    barcode: '',
    stock: 0,
    reorderPoint: 5,
    supplier: '',
    imageUrl: '',
    images: [] as string[],
    entryDate: new Date().toISOString().split('T')[0],
    sedeId: defaultSedeId || '',
  }
}
