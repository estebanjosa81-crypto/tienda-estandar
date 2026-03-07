"use client";

import { useState } from 'react';

const formatCOP = (value: number) =>
  new Intl.NumberFormat('es-CO', { style: 'currency', currency: 'COP', minimumFractionDigits: 0, maximumFractionDigits: 0 }).format(value);
import { Minus, Plus, Trash2, Ticket, X, Check, Loader2, AlertCircle, Zap, ShoppingCart, Package, CreditCard, Sparkles } from 'lucide-react';

interface FieldError {
  field: string;
  message: string;
}

const REQUIRED_FIELDS: { field: keyof import('@/types').PedidoForm; label: string }[] = [
  { field: 'nombre', label: 'Nombre completo' },
  { field: 'telefono', label: 'Teléfono / WhatsApp' },
  { field: 'email', label: 'Correo electrónico' },
  { field: 'cedula', label: 'Cédula / Documento' },
  { field: 'departamento', label: 'Departamento' },
  { field: 'municipio', label: 'Municipio' },
  { field: 'direccion', label: 'Dirección de entrega' },
];
import { departamentosMunicipios } from '@/constants';
import { ModalExito } from './ModalExito';
import { LocationPicker } from './LocationPicker';
import type { ProductoCarrito, PedidoForm, PedidoConfirmado, CuponValidacion } from '@/types';

interface OrderBumpProduct {
  id: string;
  name: string;
  category: string;
  brand: string | null;
  description: string | null;
  salePrice: number;
  imageUrl: string | null;
  stock: number;
  isOnOffer?: boolean | number;
  offerPrice?: number | null;
  offerLabel?: string | null;
}

interface CheckoutViewProps {
  carrito: ProductoCarrito[];
  totalCarrito: number;
  formData: PedidoForm;
  enviandoEmail: boolean;
  mostrarModalExito: boolean;
  pedidoConfirmado: PedidoConfirmado | null;
  // Cupones
  cuponCodigo?: string;
  cuponAplicado?: CuponValidacion | null;
  totalConDescuento?: number;
  onValidarCupon?: (codigo: string, subtotal: number) => Promise<CuponValidacion>;
  onAplicarCupon?: (codigo: string, descuento: CuponValidacion) => void;
  onRemoverCupon?: () => void;
  // Geolocalización
  deliveryLatitude?: number | null;
  deliveryLongitude?: number | null;
  isDeliveryOrder?: boolean;
  onLocationChange?: (lat: number, lng: number) => void;
  onInputChange: (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>) => void;
  onActualizarCantidad: (id: number, cambio: number, tempId?: string) => void;
  onRemoverProducto: (producto: ProductoCarrito) => void;
  onConfirmar: () => void;
  onCerrarModal: () => void;
  onVolver: () => void;
  // Order Bump / Cross-sell
  orderBumpProducts?: OrderBumpProduct[];
  orderBumpTitle?: string;
  onAddBumpProduct?: (product: OrderBumpProduct) => void;
  // MercadoPago Checkout Pro
  onPagarEnLinea?: () => Promise<void>;
}

export function CheckoutView({
  carrito,
  totalCarrito,
  formData,
  enviandoEmail,
  mostrarModalExito,
  pedidoConfirmado,
  cuponCodigo = '',
  cuponAplicado,
  totalConDescuento,
  onValidarCupon,
  onAplicarCupon,
  onRemoverCupon,
  deliveryLatitude,
  deliveryLongitude,
  isDeliveryOrder = false,
  onLocationChange,
  onInputChange,
  onActualizarCantidad,
  onRemoverProducto,
  onConfirmar,
  onCerrarModal,
  onVolver,
  orderBumpProducts = [],
  orderBumpTitle = '¿También te puede interesar?',
  onAddBumpProduct,
  onPagarEnLinea,
}: CheckoutViewProps) {
  const [inputCupon, setInputCupon] = useState(cuponCodigo);
  const [validandoCupon, setValidandoCupon] = useState(false);
  const [errorCupon, setErrorCupon] = useState('');
  const [fieldErrors, setFieldErrors] = useState<FieldError[]>([]);
  const [addedBumpIds, setAddedBumpIds] = useState<Set<string>>(new Set());
  const [loadingMP, setLoadingMP] = useState(false);
  const [errorMP, setErrorMP] = useState('');

  const validateForm = (): boolean => {
    const errors: FieldError[] = [];
    for (const { field, label } of REQUIRED_FIELDS) {
      if (!formData[field] || !formData[field].trim()) {
        errors.push({ field, message: `${label} es obligatorio` });
      }
    }
    // Validate email format
    if (formData.email && formData.email.trim() && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email.trim())) {
      const existing = errors.find(e => e.field === 'email');
      if (!existing) errors.push({ field: 'email', message: 'Correo electrónico no válido' });
    }
    // Validate phone (at least 7 digits)
    if (formData.telefono && formData.telefono.trim() && !/^\d{7,}$/.test(formData.telefono.trim().replace(/[\s\-\+]/g, ''))) {
      const existing = errors.find(e => e.field === 'telefono');
      if (!existing) errors.push({ field: 'telefono', message: 'Teléfono no válido (mínimo 7 dígitos)' });
    }
    setFieldErrors(errors);
    if (errors.length > 0) {
      // Scroll to the first error field
      const firstErrorField = document.querySelector(`[name="${errors[0].field}"]`);
      firstErrorField?.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
    return errors.length === 0;
  };

  const handleConfirmar = () => {
    if (validateForm()) {
      onConfirmar();
    }
  };

  const handlePagarEnLinea = async () => {
    if (!onPagarEnLinea) return;
    if (!validateForm()) return;
    setLoadingMP(true);
    setErrorMP('');
    try {
      await onPagarEnLinea();
    } catch {
      setErrorMP('Error al iniciar el pago en línea. Intenta de nuevo.');
    } finally {
      setLoadingMP(false);
    }
  };

  const getFieldError = (field: string) => fieldErrors.find(e => e.field === field);
  const hasFieldError = (field: string) => fieldErrors.some(e => e.field === field);

  // Clear field error when user types
  const handleInputChangeWithClear = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>) => {
    const { name } = e.target;
    if (hasFieldError(name)) {
      setFieldErrors(prev => prev.filter(err => err.field !== name));
    }
    onInputChange(e);
  };

  const handleValidarCupon = async () => {
    if (!inputCupon.trim() || !onValidarCupon) return;

    setValidandoCupon(true);
    setErrorCupon('');

    try {
      const resultado = await onValidarCupon(inputCupon.trim().toUpperCase(), totalCarrito);
      if (resultado.valido && onAplicarCupon) {
        onAplicarCupon(inputCupon.trim().toUpperCase(), resultado);
        setErrorCupon('');
      } else {
        setErrorCupon(resultado.mensaje || 'Cupón no válido');
      }
    } catch (error) {
      setErrorCupon('Error al validar cupón');
    } finally {
      setValidandoCupon(false);
    }
  };

  const handleRemoverCupon = () => {
    setInputCupon('');
    setErrorCupon('');
    if (onRemoverCupon) onRemoverCupon();
  };

  const totalFinal = totalConDescuento ?? totalCarrito;
  const descuentoAplicado = cuponAplicado?.valido ? cuponAplicado.descuento || 0 : 0;

  return (
    <div className="min-h-screen bg-white p-4">
      <div className="max-w-5xl mx-auto">
        <button
          onClick={onVolver}
          className="mb-8 text-gray-600 hover:text-gray-900 flex items-center gap-2 font-light text-sm tracking-wide"
        >
          ← VOLVER
        </button>

        <div className="border border-gray-200 p-6 sm:p-10 light-form">
          <h1 className="text-2xl sm:text-3xl font-light tracking-wide text-gray-900 mb-2">
            {isDeliveryOrder ? 'Pedir Domicilio' : 'Finalizar Compra'}
          </h1>
          <p className="text-gray-500 mb-10 font-light text-sm">
            {isDeliveryOrder ? 'Confirma tu dirección de entrega para el domicilio' : 'Completa tus datos para procesar tu pedido'}
          </p>

          {/* Error summary */}
          {fieldErrors.length > 0 && (
            <div className="mb-8 p-4 border border-red-300 bg-red-50 rounded">
              <div className="flex items-center gap-2 mb-2">
                <AlertCircle className="w-5 h-5 text-red-500 flex-shrink-0" />
                <span className="text-sm font-medium text-red-700">Por favor completa los siguientes campos:</span>
              </div>
              <ul className="list-disc list-inside space-y-1">
                {fieldErrors.map(err => (
                  <li key={err.field} className="text-sm text-red-600">{err.message}</li>
                ))}
              </ul>
            </div>
          )}

          <div className="grid md:grid-cols-2 gap-8 sm:gap-12">
            {/* Columna izquierda - Datos */}
            <div className="space-y-8">
              {/* Datos del Comprador */}
              <div>
                <h2 className="text-lg font-light tracking-wide text-gray-900 mb-6 pb-2 border-b border-gray-200">
                  Datos del Comprador
                </h2>
                <div className="space-y-5">
                  <div>
                    <label className="block text-xs font-medium text-gray-700 mb-2 tracking-wide">
                      NOMBRE COMPLETO *
                    </label>
                    <input
                      type="text"
                      name="nombre"
                      value={formData.nombre}
                      onChange={handleInputChangeWithClear}
                      className={`w-full px-4 py-3 border bg-white text-gray-900 focus:ring-1 font-light rounded-none placeholder-gray-400 ${hasFieldError('nombre') ? 'border-red-400 focus:border-red-500 focus:ring-red-500' : 'border-gray-300 focus:border-gray-900 focus:ring-gray-900'}`}
                      placeholder="Ingresa tu nombre completo"
                      required
                    />
                    {getFieldError('nombre') && <p className="text-xs text-red-500 mt-1">{getFieldError('nombre')!.message}</p>}
                  </div>
                  <div>
                    <label className="block text-xs font-medium text-gray-700 mb-2 tracking-wide">
                      TELÉFONO / WHATSAPP *
                    </label>
                    <input
                      type="tel"
                      name="telefono"
                      value={formData.telefono}
                      onChange={handleInputChangeWithClear}
                      className={`w-full px-4 py-3 border bg-white text-gray-900 focus:ring-1 font-light rounded-none placeholder-gray-400 ${hasFieldError('telefono') ? 'border-red-400 focus:border-red-500 focus:ring-red-500' : 'border-gray-300 focus:border-gray-900 focus:ring-gray-900'}`}
                      placeholder="Ej: 3001234567"
                      required
                    />
                    {getFieldError('telefono') && <p className="text-xs text-red-500 mt-1">{getFieldError('telefono')!.message}</p>}
                  </div>
                  <div>
                    <label className="block text-xs font-medium text-gray-700 mb-2 tracking-wide">
                      CORREO ELECTRÓNICO *
                    </label>
                    <input
                      type="email"
                      name="email"
                      value={formData.email}
                      onChange={handleInputChangeWithClear}
                      className={`w-full px-4 py-3 border bg-white text-gray-900 focus:ring-1 font-light rounded-none placeholder-gray-400 ${hasFieldError('email') ? 'border-red-400 focus:border-red-500 focus:ring-red-500' : 'border-gray-300 focus:border-gray-900 focus:ring-gray-900'}`}
                      placeholder="ejemplo@correo.com"
                      required
                    />
                    {getFieldError('email') && <p className="text-xs text-red-500 mt-1">{getFieldError('email')!.message}</p>}
                  </div>
                  <div>
                    <label className="block text-xs font-medium text-gray-700 mb-2 tracking-wide">
                      CÉDULA / DOCUMENTO *
                    </label>
                    <input
                      type="text"
                      name="cedula"
                      value={formData.cedula}
                      onChange={handleInputChangeWithClear}
                      className={`w-full px-4 py-3 border bg-white text-gray-900 focus:ring-1 font-light rounded-none placeholder-gray-400 ${hasFieldError('cedula') ? 'border-red-400 focus:border-red-500 focus:ring-red-500' : 'border-gray-300 focus:border-gray-900 focus:ring-gray-900'}`}
                      placeholder="Número de documento"
                      required
                    />
                    {getFieldError('cedula') && <p className="text-xs text-red-500 mt-1">{getFieldError('cedula')!.message}</p>}
                  </div>
                </div>
              </div>

              {/* Datos de Envío */}
              <div>
                <h2 className="text-lg font-light tracking-wide text-gray-900 mb-6 pb-2 border-b border-gray-200">
                  Datos de Envío
                </h2>
                <div className="space-y-5">
                  <div>
                    <label className="block text-xs font-medium text-gray-700 mb-2 tracking-wide">
                      DEPARTAMENTO *
                    </label>
                    <select
                      name="departamento"
                      value={formData.departamento}
                      onChange={handleInputChangeWithClear}
                      className={`w-full px-4 py-3 border bg-white text-gray-900 focus:ring-1 font-light rounded-none ${hasFieldError('departamento') ? 'border-red-400 focus:border-red-500 focus:ring-red-500' : 'border-gray-300 focus:border-gray-900 focus:ring-gray-900'}`}
                      required
                    >
                      <option value="">Selecciona departamento</option>
                      {Object.keys(departamentosMunicipios).map(dep => (
                        <option key={dep} value={dep}>{dep}</option>
                      ))}
                    </select>
                    {getFieldError('departamento') && <p className="text-xs text-red-500 mt-1">{getFieldError('departamento')!.message}</p>}
                  </div>
                  <div>
                    <label className="block text-xs font-medium text-gray-700 mb-2 tracking-wide">
                      MUNICIPIO *
                    </label>
                    <select
                      name="municipio"
                      value={formData.municipio}
                      onChange={handleInputChangeWithClear}
                      className={`w-full px-4 py-3 border bg-white text-gray-900 focus:ring-1 font-light rounded-none disabled:bg-gray-100 disabled:text-gray-500 ${hasFieldError('municipio') ? 'border-red-400 focus:border-red-500 focus:ring-red-500' : 'border-gray-300 focus:border-gray-900 focus:ring-gray-900'}`}
                      required
                      disabled={!formData.departamento}
                    >
                      <option value="">
                        {formData.departamento ? 'Selecciona municipio' : 'Primero selecciona departamento'}
                      </option>
                      {formData.departamento && departamentosMunicipios[formData.departamento]?.map(mun => (
                        <option key={mun} value={mun}>{mun}</option>
                      ))}
                    </select>
                    {getFieldError('municipio') && <p className="text-xs text-red-500 mt-1">{getFieldError('municipio')!.message}</p>}
                  </div>
                  <div>
                    <label className="block text-xs font-medium text-gray-700 mb-2 tracking-wide">
                      DIRECCIÓN DE ENTREGA *
                    </label>
                    <input
                      type="text"
                      name="direccion"
                      value={formData.direccion}
                      onChange={handleInputChangeWithClear}
                      className={`w-full px-4 py-3 border bg-white text-gray-900 focus:ring-1 font-light rounded-none placeholder-gray-400 ${hasFieldError('direccion') ? 'border-red-400 focus:border-red-500 focus:ring-red-500' : 'border-gray-300 focus:border-gray-900 focus:ring-gray-900'}`}
                      placeholder="Calle, carrera, número..."
                      required
                    />
                    {getFieldError('direccion') && <p className="text-xs text-red-500 mt-1">{getFieldError('direccion')!.message}</p>}
                  </div>

                  {/* Mapa de ubicación */}
                  {onLocationChange && (
                    <div className="mt-2">
                      <LocationPicker
                        latitude={deliveryLatitude ?? null}
                        longitude={deliveryLongitude ?? null}
                        onChange={onLocationChange}
                      />
                    </div>
                  )}

                  <div>
                    <label className="block text-xs font-medium text-gray-700 mb-2 tracking-wide">
                      BARRIO
                    </label>
                    <input
                      type="text"
                      name="barrio"
                      value={formData.barrio}
                      onChange={handleInputChangeWithClear}
                      className="w-full px-4 py-3 border border-gray-300 bg-white text-gray-900 focus:border-gray-900 focus:ring-1 focus:ring-gray-900 font-light rounded-none placeholder-gray-400"
                      placeholder="Nombre del barrio"
                    />
                  </div>
                </div>
              </div>
            </div>

            {/* Columna derecha - Resumen */}
            <div>
              <h2 className="text-lg font-light tracking-wide text-gray-900 mb-6 pb-2 border-b border-gray-200">
                Resumen del Pedido
              </h2>
              <div className="space-y-6">
                {carrito.map((item, index) => (
                  <div key={`${item.id}-${item.tallaSeleccionada || ''}-${item.colorSeleccionado || ''}-${index}`} className="pb-6 border-b border-gray-100 last:border-0">
                    <div className="flex justify-between items-start mb-2">
                      <div>
                        <div className="font-light text-gray-900 text-sm">{item.nombre}</div>
                        {(item.tallaSeleccionada || item.colorSeleccionado) && (
                          <div className="text-xs text-gray-500 mt-1">
                            {item.tallaSeleccionada && <span>Talla: {item.tallaSeleccionada}</span>}
                            {item.tallaSeleccionada && item.colorSeleccionado && <span> / </span>}
                            {item.colorSeleccionado && <span>Color: {item.colorSeleccionado}</span>}
                          </div>
                        )}
                      </div>
                      <button
                        onClick={() => onRemoverProducto(item)}
                        className="p-1 text-gray-400 hover:text-red-500 transition-colors"
                        title="Eliminar producto"
                      >
                        <Trash2 size={16} />
                      </button>
                    </div>
                    <div className="flex justify-between items-center">
                      <div className="flex items-center gap-3">
                        <button
                          onClick={() => onActualizarCantidad(item.id, -1, item.tempId)}
                          className="w-8 h-8 border border-gray-300 bg-white text-gray-700 flex items-center justify-center hover:bg-gray-100 hover:border-gray-900 transition-colors"
                        >
                          <Minus size={14} />
                        </button>
                        <span className="font-medium text-sm w-8 text-center text-gray-900">{item.cantidad}</span>
                        <button
                          onClick={() => onActualizarCantidad(item.id, 1, item.tempId)}
                          className="w-8 h-8 border border-gray-300 bg-white text-gray-700 flex items-center justify-center hover:bg-gray-100 hover:border-gray-900 transition-colors"
                        >
                          <Plus size={14} />
                        </button>
                      </div>
                      <div className="text-right">
                        <div className="text-xs text-gray-500 font-light mb-1 flex items-center justify-end gap-1">
                          <span>{formatCOP(item.precio)} c/u</span>
                          {item.precioOriginal && item.precioOriginal > item.precio && (
                            <span className="line-through text-gray-300">{formatCOP(item.precioOriginal)}</span>
                          )}
                        </div>
                        {item.descuentoPorcentaje && item.descuentoPorcentaje > 0 && (
                          <div className="text-[10px] text-green-600 mb-0.5">-{item.descuentoPorcentaje}% dto.</div>
                        )}
                        <div className="font-light text-gray-900">
                          {formatCOP(item.precio * item.cantidad)}
                        </div>
                      </div>
                    </div>
                  </div>
                ))}

                {/* ====== ORDER BUMP / CROSS-SELL ====== */}
                {orderBumpProducts.length > 0 && onAddBumpProduct && (
                  <div className="pt-4 border-t border-amber-200">
                    <div className="flex items-center gap-2 mb-3">
                      <Zap className="w-4 h-4 text-amber-500 flex-shrink-0" />
                      <span className="text-xs font-semibold text-amber-700 uppercase tracking-wide">
                        {orderBumpTitle}
                      </span>
                    </div>
                    <div className="space-y-2">
                      {orderBumpProducts.map(bp => {
                        const isAdded = addedBumpIds.has(bp.id);
                        const displayPrice = (bp.isOnOffer && bp.offerPrice) ? bp.offerPrice : bp.salePrice;
                        const hasDiscount = bp.isOnOffer && bp.offerPrice && bp.offerPrice < bp.salePrice;
                        return (
                          <div
                            key={bp.id}
                            className={`flex items-center gap-3 p-3 rounded-lg border transition-colors ${
                              isAdded
                                ? 'border-green-300 bg-green-50'
                                : 'border-amber-200 bg-amber-50/60 hover:bg-amber-50'
                            }`}
                          >
                            {bp.imageUrl ? (
                              // eslint-disable-next-line @next/next/no-img-element
                              <img
                                src={bp.imageUrl}
                                alt={bp.name}
                                className="h-12 w-12 object-cover rounded flex-shrink-0"
                              />
                            ) : (
                              <div className="h-12 w-12 rounded bg-amber-100 flex items-center justify-center flex-shrink-0">
                                <Package className="h-6 w-6 text-amber-400" />
                              </div>
                            )}
                            <div className="flex-1 min-w-0">
                              <p className="text-sm font-medium text-gray-900 line-clamp-1">{bp.name}</p>
                              <div className="flex items-center gap-1.5 mt-0.5">
                                <span className="text-sm font-semibold text-amber-700">
                                  {formatCOP(displayPrice)}
                                </span>
                                {hasDiscount && (
                                  <span className="text-xs text-gray-400 line-through">{formatCOP(bp.salePrice)}</span>
                                )}
                              </div>
                              {bp.offerLabel && (
                                <span className="text-xs text-orange-600 font-medium">{bp.offerLabel}</span>
                              )}
                            </div>
                            <button
                              onClick={() => {
                                if (!isAdded) {
                                  setAddedBumpIds(prev => new Set(prev).add(bp.id));
                                  onAddBumpProduct(bp);
                                }
                              }}
                              disabled={isAdded}
                              className={`flex-shrink-0 flex items-center gap-1 px-3 py-1.5 rounded text-xs font-medium transition-colors ${
                                isAdded
                                  ? 'bg-green-500 text-white cursor-default'
                                  : 'bg-amber-500 hover:bg-amber-600 text-white'
                              }`}
                            >
                              {isAdded ? (
                                <><Check className="w-3.5 h-3.5" /> Añadido</>
                              ) : (
                                <><ShoppingCart className="w-3.5 h-3.5" /> Añadir</>
                              )}
                            </button>
                          </div>
                        );
                      })}
                    </div>
                  </div>
                )}

                {/* Cupón de descuento */}
                {onValidarCupon && (
                  <div className="pt-6 border-t border-gray-200">
                    <label className="block text-xs font-medium text-gray-700 mb-2 tracking-wide">
                      CUPÓN DE DESCUENTO
                    </label>
                    {cuponAplicado?.valido ? (
                      <div className="flex items-center justify-between bg-green-50 border border-green-200 p-3 rounded">
                        <div className="flex items-center gap-2">
                          <Check className="w-4 h-4 text-green-600" />
                          <span className="text-sm text-green-700 font-medium">{cuponCodigo}</span>
                          <span className="text-xs text-green-600">-{formatCOP(descuentoAplicado)}</span>
                        </div>
                        <button
                          onClick={handleRemoverCupon}
                          className="p-1 text-green-600 hover:text-red-500 transition-colors"
                        >
                          <X size={16} />
                        </button>
                      </div>
                    ) : (
                      <div className="flex gap-2">
                        <div className="relative flex-1">
                          <Ticket className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
                          <input
                            type="text"
                            value={inputCupon}
                            onChange={(e) => {
                              setInputCupon(e.target.value.toUpperCase());
                              setErrorCupon('');
                            }}
                            placeholder="Código de cupón"
                            className="w-full pl-9 pr-4 py-2 border border-gray-300 bg-white text-gray-900 focus:border-gray-900 focus:ring-1 focus:ring-gray-900 font-light text-sm rounded-none"
                          />
                        </div>
                        <button
                          onClick={handleValidarCupon}
                          disabled={validandoCupon || !inputCupon.trim()}
                          className="px-4 py-2 bg-gray-900 text-white text-sm font-medium hover:bg-gray-700 disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors flex items-center gap-2"
                        >
                          {validandoCupon ? <Loader2 className="w-4 h-4 animate-spin" /> : 'APLICAR'}
                        </button>
                      </div>
                    )}
                    {errorCupon && (
                      <p className="text-xs text-red-500 mt-1">{errorCupon}</p>
                    )}
                  </div>
                )}

                <div className="pt-6 border-t border-gray-300">
                  {descuentoAplicado > 0 && (
                    <>
                      <div className="flex justify-between items-center mb-2">
                        <span className="text-sm font-light text-gray-600">Subtotal</span>
                        <span className="text-sm font-light text-gray-600">{formatCOP(totalCarrito)}</span>
                      </div>
                      <div className="flex justify-between items-center mb-2">
                        <span className="text-sm font-light text-green-600">Descuento</span>
                        <span className="text-sm font-light text-green-600">-{formatCOP(descuentoAplicado)}</span>
                      </div>
                    </>
                  )}
                  <div className="flex justify-between items-center">
                    <span className="text-sm font-light tracking-wide text-gray-600">TOTAL</span>
                    <span className="text-xl font-light text-gray-900">{formatCOP(totalFinal)}</span>
                  </div>
                </div>

                <div className="mt-8">
                  <label className="block text-xs font-medium text-gray-700 mb-2 tracking-wide">
                    NOTAS ADICIONALES
                  </label>
                  <textarea
                    name="notas"
                    value={formData.notas}
                    onChange={handleInputChangeWithClear}
                    rows={3}
                    className="w-full px-4 py-3 border border-gray-300 bg-white text-gray-900 focus:border-gray-900 focus:ring-1 focus:ring-gray-900 font-light text-sm resize-none rounded-none placeholder-gray-400"
                    placeholder="Instrucciones especiales, preferencias de entrega..."
                  />
                </div>

                <button
                  onClick={handleConfirmar}
                  disabled={enviandoEmail}
                  className={`w-full font-medium py-4 transition-colors tracking-widest text-sm mt-6 disabled:bg-gray-400 disabled:cursor-not-allowed text-white ${isDeliveryOrder ? 'bg-blue-600 hover:bg-blue-700' : 'bg-gray-900 hover:bg-gray-700'}`}
                >
                  {enviandoEmail ? 'PROCESANDO...' : isDeliveryOrder ? 'PEDIR DOMICILIO' : 'CONFIRMAR PEDIDO'}
                </button>

                {/* ── MercadoPago Checkout Pro ── */}
                {onPagarEnLinea && !isDeliveryOrder && (
                  <div className="mt-4">
                    <div className="flex items-center gap-3 mb-3">
                      <div className="flex-1 h-px bg-gray-200" />
                      <span className="text-xs text-gray-400 uppercase tracking-widest whitespace-nowrap">o paga en línea</span>
                      <div className="flex-1 h-px bg-gray-200" />
                    </div>

                    <button
                      onClick={handlePagarEnLinea}
                      disabled={loadingMP || enviandoEmail}
                      className="animate-mp-shimmer animate-mp-shake w-full relative overflow-hidden text-white font-semibold py-4 px-6 tracking-wide text-sm disabled:opacity-60 disabled:cursor-not-allowed flex items-center justify-center gap-3 rounded-sm"
                      style={{ minHeight: 56 }}
                    >
                      {loadingMP ? (
                        <Loader2 className="w-5 h-5 animate-spin" />
                      ) : (
                        <>
                          <CreditCard className="w-5 h-5 flex-shrink-0" />
                          <span className="flex flex-col items-center leading-tight">
                            <span className="text-sm font-bold uppercase tracking-widest">Pagar con Mercado Pago</span>
                            <span className="text-xs font-light opacity-90 flex items-center gap-1">
                              <Sparkles className="w-3 h-3" />
                              10% de descuento por pago en línea
                            </span>
                          </span>
                        </>
                      )}
                    </button>

                    {errorMP && (
                      <p className="text-xs text-red-500 mt-1 text-center">{errorMP}</p>
                    )}

                    <p className="text-center text-[10px] text-gray-400 mt-2 flex items-center justify-center gap-1">
                      <svg className="w-3 h-3" viewBox="0 0 24 24" fill="currentColor"><path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4z"/></svg>
                      Pago seguro con encriptación SSL · Procesado por Mercado Pago
                    </p>
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Modal de Pedido Exitoso */}
      {mostrarModalExito && pedidoConfirmado && (
        <ModalExito pedido={pedidoConfirmado} onCerrar={onCerrarModal} />
      )}
    </div>
  );
}
