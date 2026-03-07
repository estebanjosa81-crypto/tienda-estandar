'use client'

import { useState, useCallback, useEffect } from 'react'
import { api } from '@/lib/api'
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import { Label } from '@/components/ui/label'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog'
import {
  ImageIcon,
  LayoutTemplate,
  RefreshCw,
  Plus,
  Pencil,
  Trash2,
  CalendarDays,
  Tag,
  CheckCircle2,
  XCircle,
  Sparkles,
} from 'lucide-react'
import { toast } from 'sonner'
import { formatCOP } from '@/lib/utils'

const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3001/api'

interface Drop {
  id: number
  name: string
  description?: string
  bannerUrl?: string
  globalDiscount: number
  startsAt: string
  endsAt: string
  isActive: boolean
}

const emptyDrop = (): Omit<Drop, 'id'> => ({
  name: '',
  description: '',
  bannerUrl: '',
  globalDiscount: 0,
  startsAt: '',
  endsAt: '',
  isActive: true,
})

export function SuperadminHome() {
  // ── Hero settings ──
  const [heroUrl, setHeroUrl] = useState('')
  const [heroTitle, setHeroTitle] = useState('')
  const [heroSubtitle, setHeroSubtitle] = useState('')
  const [isSavingHero, setIsSavingHero] = useState(false)

  // ── Login image settings ──
  const [loginImageUrl, setLoginImageUrl] = useState('')
  const [isSavingLogin, setIsSavingLogin] = useState(false)

  // ── Offers (products with isOnOffer) ──
  const [offers, setOffers] = useState<any[]>([])
  const [isLoadingOffers, setIsLoadingOffers] = useState(false)

  // ── Drops ──
  const [drops, setDrops] = useState<Drop[]>([])
  const [isLoadingDrops, setIsLoadingDrops] = useState(false)
  const [isDropDialogOpen, setIsDropDialogOpen] = useState(false)
  const [editingDrop, setEditingDrop] = useState<Drop | null>(null)
  const [dropForm, setDropForm] = useState<Omit<Drop, 'id'>>(emptyDrop())
  const [isSavingDrop, setIsSavingDrop] = useState(false)
  const [deletingDropId, setDeletingDropId] = useState<number | null>(null)

  const fetchPlatformSettings = useCallback(async () => {
    const result = await api.getPlatformSettings()
    if (result.success && result.data) {
      if (result.data.hero_image_url) setHeroUrl(result.data.hero_image_url)
      if (result.data.hero_title) setHeroTitle(result.data.hero_title)
      if (result.data.hero_subtitle) setHeroSubtitle(result.data.hero_subtitle)
      if (result.data.login_image_url) setLoginImageUrl(result.data.login_image_url)
    }
  }, [])

  const fetchOffers = useCallback(async () => {
    setIsLoadingOffers(true)
    try {
      const res = await fetch(`${API_URL}/storefront/products?limit=100&store=all`)
      const json = await res.json()
      if (json.success && json.data?.products) {
        setOffers(json.data.products.filter((p: any) => p.isOnOffer))
      }
    } catch {
      // silent
    }
    setIsLoadingOffers(false)
  }, [])

  const fetchDrops = useCallback(async () => {
    setIsLoadingDrops(true)
    try {
      const res = await fetch(`${API_URL}/storefront/drops`, {
        headers: { Authorization: `Bearer ${api.getToken()}` },
      })
      const json = await res.json()
      if (json.success && Array.isArray(json.data)) {
        setDrops(json.data)
      } else if (Array.isArray(json)) {
        setDrops(json)
      }
    } catch {
      // silent
    }
    setIsLoadingDrops(false)
  }, [])

  useEffect(() => {
    fetchPlatformSettings()
    fetchOffers()
    fetchDrops()
  }, [fetchPlatformSettings, fetchOffers, fetchDrops])

  const handleSaveHero = async () => {
    setIsSavingHero(true)
    try {
      const results = await Promise.all([
        api.updatePlatformSetting('hero_image_url', heroUrl),
        api.updatePlatformSetting('hero_title', heroTitle),
        api.updatePlatformSetting('hero_subtitle', heroSubtitle),
      ])
      if (results.every(r => r.success)) {
        toast.success('Hero principal actualizado')
      } else {
        toast.error('Error al guardar algunos campos')
      }
    } catch {
      toast.error('Error de conexión')
    }
    setIsSavingHero(false)
  }

  const handleSaveLoginImage = async () => {
    setIsSavingLogin(true)
    const result = await api.updatePlatformSetting('login_image_url', loginImageUrl)
    if (result.success) {
      toast.success('Imagen del login actualizada')
    } else {
      toast.error(result.error || 'Error al guardar')
    }
    setIsSavingLogin(false)
  }

  const openCreateDrop = () => {
    setEditingDrop(null)
    setDropForm(emptyDrop())
    setIsDropDialogOpen(true)
  }

  const openEditDrop = (drop: Drop) => {
    setEditingDrop(drop)
    setDropForm({
      name: drop.name,
      description: drop.description || '',
      bannerUrl: drop.bannerUrl || '',
      globalDiscount: drop.globalDiscount,
      startsAt: drop.startsAt ? drop.startsAt.slice(0, 16) : '',
      endsAt: drop.endsAt ? drop.endsAt.slice(0, 16) : '',
      isActive: drop.isActive,
    })
    setIsDropDialogOpen(true)
  }

  const handleSaveDrop = async () => {
    if (!dropForm.name || !dropForm.startsAt || !dropForm.endsAt) {
      toast.error('Nombre, fecha de inicio y fin son requeridos')
      return
    }
    setIsSavingDrop(true)
    const payload = {
      name: dropForm.name,
      description: dropForm.description || undefined,
      bannerUrl: dropForm.bannerUrl || undefined,
      globalDiscount: Number(dropForm.globalDiscount),
      startsAt: dropForm.startsAt,
      endsAt: dropForm.endsAt,
      isActive: dropForm.isActive,
    }
    const result = editingDrop
      ? await api.updateDrop(editingDrop.id, payload)
      : await api.createDrop(payload)

    if (result.success) {
      toast.success(editingDrop ? 'Drop actualizado' : 'Drop creado')
      setIsDropDialogOpen(false)
      fetchDrops()
    } else {
      toast.error(result.error || 'Error al guardar drop')
    }
    setIsSavingDrop(false)
  }

  const handleDeleteDrop = async (id: number) => {
    const result = await api.deleteDrop(id)
    if (result.success) {
      toast.success('Drop eliminado')
      setDeletingDropId(null)
      fetchDrops()
    } else {
      toast.error(result.error || 'Error al eliminar')
    }
  }

  return (
    <div className="space-y-6 lg:space-y-8">
      {/* Header */}
      <div>
        <h2 className="text-lg sm:text-xl lg:text-2xl font-semibold text-foreground flex items-center gap-2">
          <LayoutTemplate className="h-6 w-6 text-primary" />
          Página Principal
        </h2>
        <p className="text-sm text-muted-foreground">
          Gestiona el hero, imagen de login, ofertas y drops de la plataforma
        </p>
      </div>

      {/* ── Hero Principal ── */}
      <Card className="border-border bg-card">
        <CardHeader className="pb-3">
          <CardTitle className="text-base lg:text-lg flex items-center gap-2">
            <ImageIcon className="h-5 w-5 text-muted-foreground" />
            Hero Principal (Landing)
          </CardTitle>
          <CardDescription>Imagen, título y subtítulo del banner principal de la página pública</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="space-y-2">
            <Label>URL de imagen del hero</Label>
            <Input
              value={heroUrl}
              onChange={(e) => setHeroUrl(e.target.value)}
              placeholder="https://ejemplo.com/imagen.jpg o GIF"
              className="font-mono text-sm"
            />
          </div>
          {heroUrl && (
            <div className="relative w-full max-w-md h-40 rounded border border-border overflow-hidden bg-muted">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img
                src={heroUrl}
                alt="Preview hero"
                className="w-full h-full object-cover"
                onError={(e) => { (e.target as HTMLImageElement).style.display = 'none' }}
              />
            </div>
          )}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label>Título del hero</Label>
              <Input
                value={heroTitle}
                onChange={(e) => setHeroTitle(e.target.value)}
                placeholder="Ej: Bienvenidos a nuestra tienda"
              />
            </div>
            <div className="space-y-2">
              <Label>Subtítulo del hero</Label>
              <Input
                value={heroSubtitle}
                onChange={(e) => setHeroSubtitle(e.target.value)}
                placeholder="Ej: Las mejores fragancias"
              />
            </div>
          </div>
          <Button size="sm" onClick={handleSaveHero} disabled={isSavingHero}>
            {isSavingHero ? 'Guardando...' : 'Guardar Hero'}
          </Button>
        </CardContent>
      </Card>

      {/* ── Login Image/GIF ── */}
      <Card className="border-border bg-card">
        <CardHeader className="pb-3">
          <CardTitle className="text-base lg:text-lg flex items-center gap-2">
            <Sparkles className="h-5 w-5 text-muted-foreground" />
            Imagen / GIF del Login
          </CardTitle>
          <CardDescription>Imagen o GIF de fondo que se muestra en la pantalla de inicio de sesión</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="space-y-2">
            <Label>URL de imagen o GIF</Label>
            <Input
              value={loginImageUrl}
              onChange={(e) => setLoginImageUrl(e.target.value)}
              placeholder="https://ejemplo.com/login-bg.gif"
              className="font-mono text-sm"
            />
            <p className="text-xs text-muted-foreground">
              Acepta imágenes estáticas (.jpg, .png, .webp) o animadas (.gif). Se mostrará como fondo decorativo en la página de login.
            </p>
          </div>
          {loginImageUrl && (
            <div className="relative w-full max-w-xs h-48 rounded border border-border overflow-hidden bg-muted">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img
                src={loginImageUrl}
                alt="Preview login"
                className="w-full h-full object-cover"
                onError={(e) => { (e.target as HTMLImageElement).style.display = 'none' }}
              />
            </div>
          )}
          <Button size="sm" onClick={handleSaveLoginImage} disabled={isSavingLogin}>
            {isSavingLogin ? 'Guardando...' : 'Guardar imagen de login'}
          </Button>
        </CardContent>
      </Card>

      {/* ── Ofertas activas ── */}
      <Card className="border-border bg-card">
        <CardHeader className="pb-3">
          <div className="flex items-center justify-between">
            <div>
              <CardTitle className="text-base lg:text-lg flex items-center gap-2">
                <Tag className="h-5 w-5 text-orange-500" />
                Ofertas Activas en Comercios
              </CardTitle>
              <CardDescription>Productos con oferta activa en todas las tiendas</CardDescription>
            </div>
            <Button variant="outline" size="sm" onClick={fetchOffers} disabled={isLoadingOffers} className="gap-1">
              <RefreshCw className={`h-4 w-4 ${isLoadingOffers ? 'animate-spin' : ''}`} />
              Actualizar
            </Button>
          </div>
        </CardHeader>
        <CardContent>
          {isLoadingOffers ? (
            <div className="flex items-center justify-center py-10">
              <RefreshCw className="h-5 w-5 animate-spin text-muted-foreground" />
            </div>
          ) : offers.length === 0 ? (
            <div className="flex flex-col items-center justify-center py-10 text-muted-foreground">
              <Tag className="h-10 w-10 mb-2 opacity-40" />
              <p className="text-sm">No hay productos en oferta actualmente</p>
              <p className="text-xs mt-1">Los comerciantes pueden activar ofertas desde el módulo Tienda</p>
            </div>
          ) : (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-3">
              {offers.map((product: any) => (
                <div key={product.id} className="flex gap-3 p-3 border border-border rounded-lg bg-background">
                  <div className="w-14 h-14 shrink-0 rounded-md overflow-hidden bg-muted flex items-center justify-center">
                    {product.imageUrl ? (
                      // eslint-disable-next-line @next/next/no-img-element
                      <img
                        src={product.imageUrl.startsWith('http') ? product.imageUrl : `${API_URL.replace('/api', '')}${product.imageUrl}`}
                        alt={product.name}
                        className="w-full h-full object-cover"
                      />
                    ) : (
                      <Sparkles className="h-5 w-5 text-muted-foreground/30" />
                    )}
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-sm font-medium text-foreground truncate">{product.name}</p>
                    <p className="text-xs text-muted-foreground truncate">{product.tenantName || product.brand || ''}</p>
                    <div className="flex items-center gap-1.5 mt-1">
                      <span className="text-sm font-semibold text-orange-500">{formatCOP(product.offerPrice)}</span>
                      <span className="text-xs text-muted-foreground line-through">{formatCOP(product.salePrice)}</span>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>

      {/* ── Drops ── */}
      <Card className="border-border bg-card">
        <CardHeader className="pb-3">
          <div className="flex items-center justify-between">
            <div>
              <CardTitle className="text-base lg:text-lg flex items-center gap-2">
                <CalendarDays className="h-5 w-5 text-purple-500" />
                Drops / Eventos de Descuento
              </CardTitle>
              <CardDescription>Eventos temporales con descuento global para productos seleccionados</CardDescription>
            </div>
            <div className="flex gap-2">
              <Button variant="outline" size="sm" onClick={fetchDrops} disabled={isLoadingDrops} className="gap-1">
                <RefreshCw className={`h-4 w-4 ${isLoadingDrops ? 'animate-spin' : ''}`} />
              </Button>
              <Button size="sm" onClick={openCreateDrop} className="gap-1">
                <Plus className="h-4 w-4" />
                Nuevo Drop
              </Button>
            </div>
          </div>
        </CardHeader>
        <CardContent>
          {isLoadingDrops ? (
            <div className="flex items-center justify-center py-10">
              <RefreshCw className="h-5 w-5 animate-spin text-muted-foreground" />
            </div>
          ) : drops.length === 0 ? (
            <div className="flex flex-col items-center justify-center py-10 text-muted-foreground">
              <CalendarDays className="h-10 w-10 mb-2 opacity-40" />
              <p className="text-sm">No hay drops creados</p>
              <p className="text-xs mt-1">Crea un drop para activar descuentos temporales</p>
            </div>
          ) : (
            <div className="space-y-3">
              {drops.map((drop) => {
                const now = new Date()
                const start = new Date(drop.startsAt)
                const end = new Date(drop.endsAt)
                const isLive = drop.isActive && now >= start && now <= end
                const isPast = now > end
                return (
                  <div key={drop.id} className="flex items-center gap-4 p-4 border border-border rounded-lg bg-background">
                    {drop.bannerUrl ? (
                      // eslint-disable-next-line @next/next/no-img-element
                      <img
                        src={drop.bannerUrl}
                        alt={drop.name}
                        className="w-16 h-12 rounded object-cover shrink-0 border border-border"
                      />
                    ) : (
                      <div className="w-16 h-12 rounded bg-secondary flex items-center justify-center shrink-0">
                        <CalendarDays className="h-5 w-5 text-muted-foreground/50" />
                      </div>
                    )}
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2">
                        <p className="text-sm font-semibold text-foreground">{drop.name}</p>
                        {isLive && (
                          <span className="px-1.5 py-0.5 text-[10px] font-bold rounded bg-green-500/15 text-green-500 border border-green-500/20">EN VIVO</span>
                        )}
                        {isPast && (
                          <span className="px-1.5 py-0.5 text-[10px] font-bold rounded bg-muted text-muted-foreground">FINALIZADO</span>
                        )}
                        {!drop.isActive && !isPast && (
                          <span className="px-1.5 py-0.5 text-[10px] font-bold rounded bg-yellow-500/15 text-yellow-500 border border-yellow-500/20">INACTIVO</span>
                        )}
                      </div>
                      {drop.description && (
                        <p className="text-xs text-muted-foreground truncate mt-0.5">{drop.description}</p>
                      )}
                      <div className="flex items-center gap-3 mt-1 flex-wrap">
                        <span className="text-xs text-purple-400 font-medium">{drop.globalDiscount}% descuento</span>
                        <span className="text-xs text-muted-foreground">
                          {new Date(drop.startsAt).toLocaleDateString('es-CO')} → {new Date(drop.endsAt).toLocaleDateString('es-CO')}
                        </span>
                      </div>
                    </div>
                    <div className="flex items-center gap-1 shrink-0">
                      <Button variant="ghost" size="icon" className="h-8 w-8" onClick={() => openEditDrop(drop)}>
                        <Pencil className="h-4 w-4" />
                      </Button>
                      <Button variant="ghost" size="icon" className="h-8 w-8 text-destructive/70 hover:text-destructive" onClick={() => setDeletingDropId(drop.id)}>
                        <Trash2 className="h-4 w-4" />
                      </Button>
                    </div>
                  </div>
                )
              })}
            </div>
          )}
        </CardContent>
      </Card>

      {/* ── Drop Create/Edit Dialog ── */}
      <Dialog open={isDropDialogOpen} onOpenChange={setIsDropDialogOpen}>
        <DialogContent className="max-w-md max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <CalendarDays className="h-5 w-5 text-purple-500" />
              {editingDrop ? 'Editar Drop' : 'Nuevo Drop'}
            </DialogTitle>
            <DialogDescription>
              Configura un evento de descuento temporal para la plataforma
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4 py-2">
            <div className="space-y-2">
              <Label>Nombre <span className="text-destructive">*</span></Label>
              <Input
                placeholder="Ej: Black Friday, Temporada de Fraggancias"
                value={dropForm.name}
                onChange={(e) => setDropForm(f => ({ ...f, name: e.target.value }))}
              />
            </div>
            <div className="space-y-2">
              <Label>Descripción</Label>
              <Input
                placeholder="Descripción opcional del evento"
                value={dropForm.description}
                onChange={(e) => setDropForm(f => ({ ...f, description: e.target.value }))}
              />
            </div>
            <div className="space-y-2">
              <Label>URL del banner</Label>
              <Input
                placeholder="https://ejemplo.com/banner.jpg"
                value={dropForm.bannerUrl}
                onChange={(e) => setDropForm(f => ({ ...f, bannerUrl: e.target.value }))}
                className="font-mono text-sm"
              />
            </div>
            <div className="space-y-2">
              <Label>Descuento global (%)</Label>
              <Input
                type="number"
                min={0}
                max={100}
                value={dropForm.globalDiscount}
                onChange={(e) => setDropForm(f => ({ ...f, globalDiscount: Number(e.target.value) }))}
              />
              <p className="text-xs text-muted-foreground">Porcentaje de descuento aplicado a todos los productos del drop</p>
            </div>
            <div className="grid grid-cols-2 gap-3">
              <div className="space-y-2">
                <Label>Fecha inicio <span className="text-destructive">*</span></Label>
                <Input
                  type="datetime-local"
                  value={dropForm.startsAt}
                  onChange={(e) => setDropForm(f => ({ ...f, startsAt: e.target.value }))}
                />
              </div>
              <div className="space-y-2">
                <Label>Fecha fin <span className="text-destructive">*</span></Label>
                <Input
                  type="datetime-local"
                  value={dropForm.endsAt}
                  onChange={(e) => setDropForm(f => ({ ...f, endsAt: e.target.value }))}
                />
              </div>
            </div>
            <div
              className={`flex items-center gap-3 p-3 rounded-lg border cursor-pointer transition-colors ${
                dropForm.isActive ? 'border-primary bg-primary/5' : 'border-border bg-muted/30'
              }`}
              onClick={() => setDropForm(f => ({ ...f, isActive: !f.isActive }))}
            >
              <div className={`w-5 h-5 rounded flex items-center justify-center border-2 flex-shrink-0 transition-colors ${
                dropForm.isActive ? 'border-primary bg-primary' : 'border-muted-foreground'
              }`}>
                {dropForm.isActive && <span className="text-white text-xs font-bold">✓</span>}
              </div>
              <div>
                <p className="text-sm font-medium">Activo</p>
                <p className="text-xs text-muted-foreground">El drop se mostrará en la página pública cuando esté en rango de fechas</p>
              </div>
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setIsDropDialogOpen(false)}>Cancelar</Button>
            <Button onClick={handleSaveDrop} disabled={isSavingDrop}>
              {isSavingDrop ? 'Guardando...' : editingDrop ? 'Guardar cambios' : 'Crear Drop'}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* ── Delete Drop Confirm ── */}
      <Dialog open={deletingDropId !== null} onOpenChange={(open) => { if (!open) setDeletingDropId(null) }}>
        <DialogContent className="max-w-sm">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2 text-destructive">
              <Trash2 className="h-5 w-5" />
              Eliminar Drop
            </DialogTitle>
            <DialogDescription>
              ¿Estás seguro de que deseas eliminar este drop? Esta acción no se puede deshacer.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter className="gap-2">
            <Button variant="outline" onClick={() => setDeletingDropId(null)}>Cancelar</Button>
            <Button variant="destructive" onClick={() => deletingDropId !== null && handleDeleteDrop(deletingDropId)}>
              Eliminar
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
}
