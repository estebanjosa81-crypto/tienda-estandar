'use client'

import { useState, useEffect } from 'react'
import { useTheme } from 'next-themes'
import { useStore } from '@/lib/store'
import { useAuthStore } from '@/lib/auth-store'
import { api } from '@/lib/api'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import { Label } from '@/components/ui/label'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog'
import {
  Store,
  User,
  Users,
  Shield,
  Bell,
  Database,
  Save,
  Trash2,
  Download,
  Upload,
  Check,
  AlertTriangle,
  Plus,
  Key,
  Loader2,
  Sun,
  Moon,
  Plug,
  Eye,
  EyeOff,
  ExternalLink,
} from 'lucide-react'

export function Settings() {
  const { storeInfo, updateStoreInfo, products, sales } = useStore()
  const { user, logout, updateProfile } = useAuthStore()
  const { theme, setTheme } = useTheme()
  const [mounted, setMounted] = useState(false)
  const [saved, setSaved] = useState(false)

  useEffect(() => { setMounted(true) }, [])
  const [showResetDialog, setShowResetDialog] = useState(false)

  // ── Cloudinary integration state ──────────────────────────────────────────
  const [cloudinaryForm, setCloudinaryForm] = useState({
    cloudName: '',
    uploadPreset: '',
  })
  const [showPreset, setShowPreset] = useState(false)

  const [cloudinaryMsg, setCloudinaryMsg] = useState<{ type: 'ok' | 'error'; text: string } | null>(null)
  const [cloudinaryLoaded, setCloudinaryLoaded] = useState(false)

  // Cargar credenciales guardadas (solo localStorage — son claves del lado cliente)
  useEffect(() => {
    if (cloudinaryLoaded) return
    setCloudinaryLoaded(true)
    setCloudinaryForm({
      cloudName: localStorage.getItem('cloudinary_cloud_name') || '',
      uploadPreset: localStorage.getItem('cloudinary_upload_preset') || '',
    })
  }, [cloudinaryLoaded])

  const handleSaveCloudinary = () => {
    if (!cloudinaryForm.cloudName.trim() || !cloudinaryForm.uploadPreset.trim()) {
      setCloudinaryMsg({ type: 'error', text: 'Completa ambos campos' })
      return
    }
    localStorage.setItem('cloudinary_cloud_name', cloudinaryForm.cloudName.trim())
    localStorage.setItem('cloudinary_upload_preset', cloudinaryForm.uploadPreset.trim())
    setCloudinaryMsg({ type: 'ok', text: 'Credenciales guardadas correctamente' })
    setTimeout(() => setCloudinaryMsg(null), 4000)
  }

  const handleClearCloudinary = () => {
    localStorage.removeItem('cloudinary_cloud_name')
    localStorage.removeItem('cloudinary_upload_preset')
    setCloudinaryForm({ cloudName: '', uploadPreset: '' })
    setCloudinaryMsg({ type: 'ok', text: 'Credenciales eliminadas' })
    setTimeout(() => setCloudinaryMsg(null), 3000)
  }
  // ─────────────────────────────────────────────────────────────────────────

  const [storeForm, setStoreForm] = useState({
    name: storeInfo.name,
    address: storeInfo.address,
    phone: storeInfo.phone,
    email: storeInfo.email,
    taxId: storeInfo.taxId
  })

  const [profileForm, setProfileForm] = useState({
    name: user?.name || '',
    email: user?.email || ''
  })

  // User management state (admin only)
  const isAdmin = user?.role === 'comerciante' || user?.role === 'superadmin'
  const [usersList, setUsersList] = useState<any[]>([])
  const [loadingUsers, setLoadingUsers] = useState(false)
  const [newUserForm, setNewUserForm] = useState({ name: '', email: '', password: '' })
  const [creatingUser, setCreatingUser] = useState(false)
  const [userError, setUserError] = useState('')
  const [userSuccess, setUserSuccess] = useState('')
  const [resetPasswordDialog, setResetPasswordDialog] = useState<{ open: boolean; userId: string; userName: string }>({ open: false, userId: '', userName: '' })
  const [newPassword, setNewPassword] = useState('')
  const [deleteUserDialog, setDeleteUserDialog] = useState<{ open: boolean; userId: string; userName: string }>({ open: false, userId: '', userName: '' })

  const fetchUsers = async () => {
    setLoadingUsers(true)
    const result = await api.getUsers({ limit: 50 })
    if (result.success && result.data) {
      const users = Array.isArray(result.data) ? result.data : (result.data as any).users || []
      setUsersList(users)
    }
    setLoadingUsers(false)
  }

  useEffect(() => {
    if (isAdmin) fetchUsers()
  }, [isAdmin])

  const handleCreateUser = async () => {
    setUserError('')
    setUserSuccess('')
    if (!newUserForm.name || !newUserForm.email || !newUserForm.password) {
      setUserError('Todos los campos son obligatorios')
      return
    }
    if (newUserForm.password.length < 6) {
      setUserError('La contraseña debe tener al menos 6 caracteres')
      return
    }
    setCreatingUser(true)
    const result = await api.createUser({ ...newUserForm, role: 'vendedor' })
    if (result.success) {
      setUserSuccess('Usuario creado exitosamente')
      setNewUserForm({ name: '', email: '', password: '' })
      fetchUsers()
    } else {
      setUserError(result.error || 'Error al crear usuario')
    }
    setCreatingUser(false)
    setTimeout(() => { setUserSuccess(''); setUserError('') }, 3000)
  }

  const handleDeleteUser = async () => {
    const result = await api.deleteUser(deleteUserDialog.userId)
    if (result.success) {
      setUserSuccess('Usuario eliminado')
      fetchUsers()
    } else {
      setUserError(result.error || 'Error al eliminar usuario')
    }
    setDeleteUserDialog({ open: false, userId: '', userName: '' })
    setTimeout(() => { setUserSuccess(''); setUserError('') }, 3000)
  }

  const handleResetPassword = async () => {
    if (newPassword.length < 6) {
      setUserError('La contraseña debe tener al menos 6 caracteres')
      return
    }
    const result = await api.resetUserPassword(resetPasswordDialog.userId, newPassword)
    if (result.success) {
      setUserSuccess('Contraseña restablecida')
    } else {
      setUserError(result.error || 'Error al restablecer contraseña')
    }
    setResetPasswordDialog({ open: false, userId: '', userName: '' })
    setNewPassword('')
    setTimeout(() => { setUserSuccess(''); setUserError('') }, 3000)
  }

  const handleSaveStore = () => {
    updateStoreInfo(storeForm)
    setSaved(true)
    setTimeout(() => setSaved(false), 2000)
  }

  const handleSaveProfile = () => {
    if (user) {
      updateProfile({ name: profileForm.name })
      setSaved(true)
      setTimeout(() => setSaved(false), 2000)
    }
  }

  const handleExportData = () => {
    const data = {
      storeInfo,
      products,
      sales,
      exportDate: new Date().toISOString()
    }
    const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `lopbuk-backup-${new Date().toISOString().split('T')[0]}.json`
    a.click()
    URL.revokeObjectURL(url)
  }

  const handleResetData = () => {
    localStorage.removeItem('lopbuk-storage')
    localStorage.removeItem('lopbuk-auth')
    window.location.reload()
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-foreground">Configuración</h1>
        <p className="text-muted-foreground">
          Administra la configuración de tu tienda y cuenta
        </p>
      </div>

      <Tabs defaultValue="store" className="space-y-6">
        <TabsList className="bg-secondary">
          <TabsTrigger value="store" className="gap-2">
            <Store className="h-4 w-4" />
            Tienda
          </TabsTrigger>
          <TabsTrigger value="profile" className="gap-2">
            <User className="h-4 w-4" />
            Perfil
          </TabsTrigger>
          <TabsTrigger value="data" className="gap-2">
            <Database className="h-4 w-4" />
            Datos
          </TabsTrigger>
          {isAdmin && (
            <TabsTrigger value="users" className="gap-2">
              <Users className="h-4 w-4" />
              Usuarios
            </TabsTrigger>
          )}
          {isAdmin && (
            <TabsTrigger value="integrations" className="gap-2">
              <Plug className="h-4 w-4" />
              Integraciones
            </TabsTrigger>
          )}
        </TabsList>

        {/* Store Settings */}
        <TabsContent value="store">
          <Card className="border-border bg-card">
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Store className="h-5 w-5 text-primary" />
                Información de la Tienda
              </CardTitle>
              <CardDescription>
                Configura los datos que aparecerán en las facturas y documentos
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                  <Label htmlFor="storeName">Nombre de la Tienda</Label>
                  <Input
                    id="storeName"
                    value={storeForm.name}
                    onChange={(e) => setStoreForm({ ...storeForm, name: e.target.value })}
                    className="bg-secondary border-none"
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="storePhone">Teléfono</Label>
                  <Input
                    id="storePhone"
                    value={storeForm.phone}
                    onChange={(e) => setStoreForm({ ...storeForm, phone: e.target.value })}
                    className="bg-secondary border-none"
                  />
                </div>
                <div className="space-y-2 md:col-span-2">
                  <Label htmlFor="storeAddress">Dirección</Label>
                  <Input
                    id="storeAddress"
                    value={storeForm.address}
                    onChange={(e) => setStoreForm({ ...storeForm, address: e.target.value })}
                    className="bg-secondary border-none"
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="storeEmail">Correo Electrónico</Label>
                  <Input
                    id="storeEmail"
                    type="email"
                    value={storeForm.email}
                    onChange={(e) => setStoreForm({ ...storeForm, email: e.target.value })}
                    className="bg-secondary border-none"
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="storeTaxId">NIT / RUT</Label>
                  <Input
                    id="storeTaxId"
                    value={storeForm.taxId}
                    onChange={(e) => setStoreForm({ ...storeForm, taxId: e.target.value })}
                    className="bg-secondary border-none"
                    placeholder="Ej: 900.123.456-7"
                  />
                </div>
              </div>
              <Button onClick={handleSaveStore} className="gap-2">
                {saved ? <Check className="h-4 w-4" /> : <Save className="h-4 w-4" />}
                {saved ? 'Guardado' : 'Guardar Cambios'}
              </Button>
            </CardContent>
          </Card>
        </TabsContent>

        {/* Profile Settings */}
        <TabsContent value="profile">
          <div className="space-y-6">
            <Card className="border-border bg-card">
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <User className="h-5 w-5 text-primary" />
                  Mi Perfil
                </CardTitle>
                <CardDescription>
                  Administra tu información personal y credenciales
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="grid gap-4 md:grid-cols-2">
                  <div className="space-y-2">
                    <Label htmlFor="userName">Nombre</Label>
                    <Input
                      id="userName"
                      value={profileForm.name}
                      onChange={(e) => setProfileForm({ ...profileForm, name: e.target.value })}
                      className="bg-secondary border-none"
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="userEmail">Correo Electrónico</Label>
                    <Input
                      id="userEmail"
                      type="email"
                      value={profileForm.email}
                      disabled
                      className="bg-secondary border-none opacity-50"
                    />
                  </div>
                  <div className="space-y-2">
                    <Label>Rol</Label>
                    <div className="flex items-center gap-2 rounded-lg bg-secondary p-3">
                      <Shield className="h-4 w-4 text-primary" />
                      <span className="text-sm capitalize">{user?.role || 'Usuario'}</span>
                    </div>
                  </div>
                  <div className="space-y-2">
                    <Label>Miembro desde</Label>
                    <div className="rounded-lg bg-secondary p-3 text-sm text-muted-foreground">
                      {user?.createdAt ? new Date(user.createdAt).toLocaleDateString('es-CO') : 'N/A'}
                    </div>
                  </div>
                </div>
                <div className="flex gap-2">
                  <Button onClick={handleSaveProfile} className="gap-2">
                    {saved ? <Check className="h-4 w-4" /> : <Save className="h-4 w-4" />}
                    {saved ? 'Guardado' : 'Guardar Cambios'}
                  </Button>
                  <Button variant="outline" onClick={logout} className="gap-2 bg-transparent">
                    Cerrar Sesión
                  </Button>
                </div>
              </CardContent>
            </Card>

            {/* Theme Settings */}
            <Card className="border-border bg-card">
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  {mounted && theme === 'dark' ? <Moon className="h-5 w-5 text-primary" /> : <Sun className="h-5 w-5 text-primary" />}
                  Tema
                </CardTitle>
                <CardDescription>
                  Selecciona el tema de la interfaz
                </CardDescription>
              </CardHeader>
              <CardContent>
                <div className="flex gap-3">
                  <button
                    onClick={() => setTheme('light')}
                    className={`flex flex-1 flex-col items-center gap-3 rounded-lg border-2 p-4 transition-colors ${mounted && theme === 'light' ? 'border-primary bg-primary/10' : 'border-border bg-secondary/50 hover:border-muted-foreground'}`}
                  >
                    <div className="flex h-12 w-12 items-center justify-center rounded-full bg-amber-100 dark:bg-amber-100">
                      <Sun className="h-6 w-6 text-amber-600" />
                    </div>
                    <span className="text-sm font-medium">Claro</span>
                  </button>
                  <button
                    onClick={() => setTheme('dark')}
                    className={`flex flex-1 flex-col items-center gap-3 rounded-lg border-2 p-4 transition-colors ${mounted && theme === 'dark' ? 'border-primary bg-primary/10' : 'border-border bg-secondary/50 hover:border-muted-foreground'}`}
                  >
                    <div className="flex h-12 w-12 items-center justify-center rounded-full bg-indigo-950">
                      <Moon className="h-6 w-6 text-indigo-300" />
                    </div>
                    <span className="text-sm font-medium">Oscuro</span>
                  </button>
                </div>
              </CardContent>
            </Card>
          </div>
        </TabsContent>

        {/* Data Settings */}
        <TabsContent value="data">
          <div className="space-y-6">
            <Card className="border-border bg-card">
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Download className="h-5 w-5 text-primary" />
                  Respaldo de Datos
                </CardTitle>
                <CardDescription>
                  Exporta todos los datos de tu inventario y ventas
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="rounded-lg bg-secondary/50 p-4">
                  <div className="grid grid-cols-2 gap-4 text-sm">
                    <div>
                      <p className="text-muted-foreground">Total Productos</p>
                      <p className="text-xl font-bold text-foreground">{products.length}</p>
                    </div>
                    <div>
                      <p className="text-muted-foreground">Total Ventas</p>
                      <p className="text-xl font-bold text-foreground">{sales.length}</p>
                    </div>
                  </div>
                </div>
                <Button onClick={handleExportData} className="gap-2">
                  <Download className="h-4 w-4" />
                  Exportar Datos (JSON)
                </Button>
              </CardContent>
            </Card>

            <Card className="border-destructive/50 bg-card">
              <CardHeader>
                <CardTitle className="flex items-center gap-2 text-destructive">
                  <AlertTriangle className="h-5 w-5" />
                  Zona de Peligro
                </CardTitle>
                <CardDescription>
                  Acciones irreversibles que afectan todos los datos
                </CardDescription>
              </CardHeader>
              <CardContent>
                <Button
                  variant="destructive"
                  onClick={() => setShowResetDialog(true)}
                  className="gap-2"
                >
                  <Trash2 className="h-4 w-4" />
                  Restablecer Todo
                </Button>
              </CardContent>
            </Card>
          </div>
        </TabsContent>
        {/* Users Management (Admin Only) */}
        {isAdmin && (
          <TabsContent value="users">
            <div className="space-y-6">
              {(userError || userSuccess) && (
                <div className={`rounded-lg p-3 text-sm ${userError ? 'bg-destructive/10 text-destructive' : 'bg-green-500/10 text-green-500'}`}>
                  {userError || userSuccess}
                </div>
              )}

              {/* Create User Form */}
              <Card className="border-border bg-card">
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Plus className="h-5 w-5 text-primary" />
                    Crear Usuario Vendedor
                  </CardTitle>
                  <CardDescription>
                    Crea un usuario que solo tendrá acceso al Punto de Venta
                  </CardDescription>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="grid gap-4 md:grid-cols-3">
                    <div className="space-y-2">
                      <Label htmlFor="newUserName">Nombre</Label>
                      <Input
                        id="newUserName"
                        value={newUserForm.name}
                        onChange={(e) => setNewUserForm({ ...newUserForm, name: e.target.value })}
                        placeholder="Nombre completo"
                        className="bg-secondary border-none"
                      />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="newUserEmail">Correo Electrónico</Label>
                      <Input
                        id="newUserEmail"
                        type="email"
                        value={newUserForm.email}
                        onChange={(e) => setNewUserForm({ ...newUserForm, email: e.target.value })}
                        placeholder="correo@ejemplo.com"
                        className="bg-secondary border-none"
                      />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="newUserPassword">Contraseña</Label>
                      <Input
                        id="newUserPassword"
                        type="password"
                        value={newUserForm.password}
                        onChange={(e) => setNewUserForm({ ...newUserForm, password: e.target.value })}
                        placeholder="Mínimo 6 caracteres"
                        className="bg-secondary border-none"
                      />
                    </div>
                  </div>
                  <div className="flex items-center gap-2 rounded-lg bg-secondary/50 p-3 text-sm text-muted-foreground">
                    <Shield className="h-4 w-4" />
                    Este usuario tendrá rol <strong className="text-foreground">vendedor</strong> y solo podrá acceder al Punto de Venta.
                  </div>
                  <Button onClick={handleCreateUser} disabled={creatingUser} className="gap-2">
                    {creatingUser ? <Loader2 className="h-4 w-4 animate-spin" /> : <Plus className="h-4 w-4" />}
                    {creatingUser ? 'Creando...' : 'Crear Usuario'}
                  </Button>
                </CardContent>
              </Card>

              {/* Users List */}
              <Card className="border-border bg-card">
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Users className="h-5 w-5 text-primary" />
                    Usuarios Registrados
                  </CardTitle>
                  <CardDescription>
                    Lista de todos los usuarios del sistema
                  </CardDescription>
                </CardHeader>
                <CardContent>
                  {loadingUsers ? (
                    <div className="flex items-center justify-center py-8">
                      <Loader2 className="h-6 w-6 animate-spin text-muted-foreground" />
                    </div>
                  ) : usersList.length === 0 ? (
                    <p className="text-center text-sm text-muted-foreground py-8">No hay usuarios registrados</p>
                  ) : (
                    <div className="space-y-2">
                      {usersList.map((u) => (
                        <div key={u.id} className="flex items-center justify-between rounded-lg bg-secondary/50 p-3">
                          <div className="flex items-center gap-3">
                            <div className="flex h-9 w-9 items-center justify-center rounded-full bg-primary/10">
                              <User className="h-4 w-4 text-primary" />
                            </div>
                            <div>
                              <p className="text-sm font-medium text-foreground">{u.name}</p>
                              <p className="text-xs text-muted-foreground">{u.email}</p>
                            </div>
                            <span className={`rounded-full px-2 py-0.5 text-xs font-medium ${u.role === 'comerciante' || u.role === 'superadmin' ? 'bg-primary/10 text-primary' : 'bg-secondary text-muted-foreground'}`}>
                              {u.role}
                            </span>
                          </div>
                          {u.id !== user?.id && (
                            <div className="flex gap-2">
                              <Button
                                variant="outline"
                                size="sm"
                                className="gap-1 bg-transparent"
                                onClick={() => setResetPasswordDialog({ open: true, userId: u.id, userName: u.name })}
                              >
                                <Key className="h-3 w-3" />
                                Contraseña
                              </Button>
                              <Button
                                variant="destructive"
                                size="sm"
                                className="gap-1"
                                onClick={() => setDeleteUserDialog({ open: true, userId: u.id, userName: u.name })}
                              >
                                <Trash2 className="h-3 w-3" />
                              </Button>
                            </div>
                          )}
                        </div>
                      ))}
                    </div>
                  )}
                </CardContent>
              </Card>
            </div>
          </TabsContent>
        )}

        {/* ── Integraciones (Admin Only) ──────────────────────────────── */}
        {isAdmin && (
          <TabsContent value="integrations">
            <div className="space-y-6">
              {/* Cloudinary Card */}
              <Card className="border-border bg-card">
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Plug className="h-5 w-5 text-primary" />
                    Cloudinary — Subida de Imágenes
                  </CardTitle>
                  <CardDescription>
                    Configura tu cuenta de Cloudinary para subir imágenes directamente desde la plataforma
                    (banners, logos, categorías y productos).
                  </CardDescription>
                </CardHeader>
                <CardContent className="space-y-5">
                  {/* How-to banner */}
                  <div className="rounded-lg bg-blue-500/10 border border-blue-500/20 p-4 text-sm space-y-1">
                    <p className="font-medium text-blue-600 dark:text-blue-400">¿Cómo obtener las credenciales?</p>
                    <ol className="list-decimal list-inside space-y-1 text-muted-foreground text-xs">
                      <li>Crea una cuenta gratuita en{' '}
                        <a
                          href="https://cloudinary.com"
                          target="_blank"
                          rel="noopener noreferrer"
                          className="underline text-blue-500 inline-flex items-center gap-0.5"
                        >
                          cloudinary.com <ExternalLink className="h-3 w-3" />
                        </a>
                      </li>
                      <li>En el Dashboard copia tu <strong>Cloud Name</strong></li>
                      <li>Ve a <strong>Settings → Upload → Upload presets</strong></li>
                      <li>Crea un preset con <strong>Signing Mode: Unsigned</strong></li>
                      <li>Copia el nombre del preset y pégalo abajo</li>
                    </ol>
                  </div>

                  {/* Feedback */}
                  {cloudinaryMsg && (
                    <div className={`rounded-lg p-3 text-sm ${cloudinaryMsg.type === 'ok' ? 'bg-green-500/10 text-green-600 dark:text-green-400' : 'bg-destructive/10 text-destructive'}`}>
                      {cloudinaryMsg.text}
                    </div>
                  )}

                  {/* Cloud Name */}
                  <div className="space-y-2">
                    <Label htmlFor="cloudName">Cloud Name</Label>
                    <Input
                      id="cloudName"
                      placeholder="ej: dxy123abc"
                      value={cloudinaryForm.cloudName}
                      onChange={e => setCloudinaryForm(prev => ({ ...prev, cloudName: e.target.value }))}
                      className="bg-secondary border-none font-mono"
                    />
                    <p className="text-xs text-muted-foreground">
                      Lo encuentras en la página principal de tu dashboard de Cloudinary.
                    </p>
                  </div>

                  {/* Upload Preset */}
                  <div className="space-y-2">
                    <Label htmlFor="uploadPreset">Upload Preset (Unsigned)</Label>
                    <div className="relative">
                      <Input
                        id="uploadPreset"
                        type={showPreset ? 'text' : 'password'}
                        placeholder="ej: perfumeria_uploads"
                        value={cloudinaryForm.uploadPreset}
                        onChange={e => setCloudinaryForm(prev => ({ ...prev, uploadPreset: e.target.value }))}
                        className="bg-secondary border-none font-mono pr-10"
                      />
                      <button
                        type="button"
                        onClick={() => setShowPreset(v => !v)}
                        className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground transition-colors"
                      >
                        {showPreset ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                      </button>
                    </div>
                    <p className="text-xs text-muted-foreground">
                      El nombre del preset <strong>Unsigned</strong> creado en Settings → Upload de Cloudinary.
                    </p>
                  </div>

                  {/* Estado actual */}
                  <div className="rounded-lg bg-secondary/50 p-3 flex items-center gap-3 text-sm">
                    <div className={`h-2.5 w-2.5 rounded-full flex-shrink-0 ${cloudinaryForm.cloudName && cloudinaryForm.uploadPreset ? 'bg-green-500' : 'bg-amber-400'}`} />
                    <span className="text-muted-foreground">
                      {cloudinaryForm.cloudName && cloudinaryForm.uploadPreset
                        ? `Configurado — Cloud: ${cloudinaryForm.cloudName}`
                        : 'Sin configurar — las imágenes se gestionan por URL manual'}
                    </span>
                  </div>

                  {/* Buttons */}
                  <div className="flex gap-2">
                    <Button onClick={handleSaveCloudinary} className="gap-2">
                      {cloudinaryMsg?.type === 'ok'
                        ? <Check className="h-4 w-4" />
                        : <Save className="h-4 w-4" />}
                      Guardar Credenciales
                    </Button>
                    {(cloudinaryForm.cloudName || cloudinaryForm.uploadPreset) && (
                      <Button variant="outline" onClick={handleClearCloudinary} className="gap-2 bg-transparent text-destructive border-destructive/30 hover:bg-destructive/10">
                        <Trash2 className="h-4 w-4" />
                        Eliminar
                      </Button>
                    )}
                  </div>
                </CardContent>
              </Card>
            </div>
          </TabsContent>
        )}
      </Tabs>

      {/* Reset Password Dialog */}
      <Dialog open={resetPasswordDialog.open} onOpenChange={(open) => !open && setResetPasswordDialog({ open: false, userId: '', userName: '' })}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Restablecer Contraseña</DialogTitle>
            <DialogDescription>
              Nueva contraseña para <strong>{resetPasswordDialog.userName}</strong>
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-2">
            <Label htmlFor="resetPassword">Nueva Contraseña</Label>
            <Input
              id="resetPassword"
              type="password"
              value={newPassword}
              onChange={(e) => setNewPassword(e.target.value)}
              placeholder="Mínimo 6 caracteres"
            />
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => { setResetPasswordDialog({ open: false, userId: '', userName: '' }); setNewPassword('') }} className="bg-transparent">
              Cancelar
            </Button>
            <Button onClick={handleResetPassword}>
              Restablecer
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Delete User Dialog */}
      <Dialog open={deleteUserDialog.open} onOpenChange={(open) => !open && setDeleteUserDialog({ open: false, userId: '', userName: '' })}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2 text-destructive">
              <AlertTriangle className="h-5 w-5" />
              Eliminar Usuario
            </DialogTitle>
            <DialogDescription>
              ¿Estás seguro de que deseas eliminar a <strong>{deleteUserDialog.userName}</strong>? Esta acción no se puede deshacer.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDeleteUserDialog({ open: false, userId: '', userName: '' })} className="bg-transparent">
              Cancelar
            </Button>
            <Button variant="destructive" onClick={handleDeleteUser}>
              Eliminar
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Reset Confirmation Dialog */}
      <Dialog open={showResetDialog} onOpenChange={setShowResetDialog}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2 text-destructive">
              <AlertTriangle className="h-5 w-5" />
              Confirmar Restablecimiento
            </DialogTitle>
            <DialogDescription>
              Esta acción eliminará TODOS los datos de la aplicación incluyendo productos, ventas, configuraciones y usuarios. Esta acción no se puede deshacer.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setShowResetDialog(false)} className="bg-transparent">
              Cancelar
            </Button>
            <Button variant="destructive" onClick={handleResetData}>
              Sí, Restablecer Todo
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
}
