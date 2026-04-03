'use client'

import { useState } from 'react'
import { useStore } from '@/lib/store'
import { useAuthStore } from '@/lib/auth-store'
import { cn } from '@/lib/utils'
import {
  LayoutDashboard,
  Package,
  ShoppingCart,
  Receipt,
  History,
  TrendingUp,
  Settings,
  X,
  Users,
  UserCheck,
  CreditCard,
  Vault,
  Crown,
  Store,
  ClipboardList,
  Ticket,
  FlaskConical,
  ShoppingBag,
  Scissors,
  LogOut,
  ChevronRight,
  ChevronDown,
  LayoutTemplate,
  Printer,
  Star,
  CalendarDays,
} from 'lucide-react'

// Items that live inside the collapsible "Tienda" group
const storeSubItems = [
  { id: 'tienda',   name: 'Mi Tienda', icon: Store,         adminOnly: true },
  { id: 'pedidos',  name: 'Pedidos',   icon: ClipboardList, adminOnly: true },
  { id: 'cupones',  name: 'Cupones',   icon: Ticket,        adminOnly: true },
  { id: 'reviews',  name: 'Reseñas',   icon: Star,          adminOnly: true },
  { id: 'services', name: 'Servicios', icon: Scissors,      adminOnly: true },
]

const storeSubIds = new Set(storeSubItems.map(i => i.id))

const navigation = [
  // superadmin-only
  { id: 'superadmin',      name: 'Panel Admin',      icon: Crown,          adminOnly: true,  superadminOnly: true,  merchantOnly: false, group: 'admin' },
  { id: 'pagina-principal',name: 'Página Principal', icon: LayoutTemplate, adminOnly: true,  superadminOnly: true,  merchantOnly: false, group: 'admin' },
  // core
  { id: 'dashboard',       name: 'Dashboard',        icon: LayoutDashboard,adminOnly: true,  superadminOnly: false, merchantOnly: true,  group: 'core' },
  { id: 'inventory',       name: 'Inventario',       icon: Package,        adminOnly: true,  superadminOnly: false, merchantOnly: true,  group: 'core' },
  // 'tienda-group' is a virtual placeholder rendered specially
  { id: 'tienda-group',    name: 'Tienda',            icon: Store,          adminOnly: true,  superadminOnly: false, merchantOnly: true,  group: 'core' },
  { id: 'recipes',         name: 'Recetas BOM',      icon: FlaskConical,   adminOnly: true,  superadminOnly: false, merchantOnly: true,  group: 'core' },
  { id: 'purchases',       name: 'Compras',          icon: ShoppingBag,    adminOnly: true,  superadminOnly: false, merchantOnly: true,  group: 'core' },
  // operations
  { id: 'pos',             name: 'Punto de Venta',   icon: ShoppingCart,   adminOnly: false, superadminOnly: false, merchantOnly: true,  group: 'ops' },
  { id: 'cash-register',   name: 'Caja',             icon: Vault,          adminOnly: false, superadminOnly: false, merchantOnly: true,  group: 'ops' },
  { id: 'invoices',        name: 'Facturación',      icon: Receipt,        adminOnly: true,  superadminOnly: false, merchantOnly: true,  group: 'ops' },
  { id: 'customers',       name: 'Clientes',         icon: Users,          adminOnly: true,  superadminOnly: false, merchantOnly: true,  group: 'ops' },
  { id: 'fiados',          name: 'Fiados',           icon: CreditCard,     adminOnly: true,  superadminOnly: false, merchantOnly: true,  group: 'ops' },
  { id: 'vendedores',      name: 'Empleados',        icon: UserCheck,      adminOnly: true,  superadminOnly: false, merchantOnly: true,  group: 'ops' },
  // reports
  { id: 'history',         name: 'Historial',        icon: History,        adminOnly: false, superadminOnly: false, merchantOnly: true,  group: 'reports' },
  { id: 'analytics',       name: 'Análisis',         icon: TrendingUp,     adminOnly: true,  superadminOnly: false, merchantOnly: true,  group: 'reports' },
  { id: 'cierre-dia',      name: 'Cierre del Día',   icon: CalendarDays,   adminOnly: true,  superadminOnly: false, merchantOnly: true,  group: 'reports' },
  // config
  { id: 'printers',        name: 'Impresoras',       icon: Printer,        adminOnly: true,  superadminOnly: false, merchantOnly: true,  group: 'config' },
  { id: 'settings',        name: 'Configuración',    icon: Settings,       adminOnly: true,  superadminOnly: false, merchantOnly: true,  group: 'config' },
]

const groups = [
  { key: 'admin',   label: null },
  { key: 'core',    label: 'Gestión' },
  { key: 'ops',     label: 'Operaciones' },
  { key: 'reports', label: 'Reportes' },
  { key: 'config',  label: null },
]

export function Sidebar() {
  const { activeSection, setActiveSection, sidebarOpen, setSidebarOpen } = useStore()
  const { user, logout } = useAuthStore()
  const [hovered, setHovered] = useState(false)
  const [storeOpen, setStoreOpen] = useState(() => storeSubIds.has(activeSection))

  const isSuperadmin = user?.role === 'superadmin'
  const isAdmin = user?.role === 'comerciante' || isSuperadmin

  const filteredNavigation = navigation.filter(item => {
    if (item.superadminOnly && !isSuperadmin) return false
    if (item.merchantOnly && isSuperadmin) return false
    if (item.adminOnly && !isAdmin) return false
    return true
  })

  const filteredStoreSubItems = storeSubItems.filter(item => {
    if (item.adminOnly && !isAdmin) return false
    return true
  })

  const roleLabel = isSuperadmin ? 'Super Admin' : isAdmin ? 'Comerciante' : 'Vendedor'
  const roleColor = isSuperadmin
    ? 'text-amber-400 bg-amber-400/10 border-amber-400/20'
    : isAdmin
    ? 'text-blue-400 bg-blue-400/10 border-blue-400/20'
    : 'text-green-400 bg-green-400/10 border-green-400/20'

  const expanded = hovered || sidebarOpen

  // Whether a store sub-item is the active section
  const storeGroupActive = storeSubIds.has(activeSection)

  const handleNavClick = (id: string) => {
    setActiveSection(id)
    setSidebarOpen(false)
  }

  const renderNavButton = (
    item: { id: string; name: string; icon: React.ElementType },
    delay: number,
    isSubItem = false,
  ) => {
    const isActive = activeSection === item.id
    return (
      <button
        key={item.id}
        onClick={() => handleNavClick(item.id)}
        title={!expanded ? item.name : undefined}
        style={!expanded && isActive ? {
          marginRight: '-12px',
          boxShadow: '0 4px 20px rgba(0,0,0,0.18)',
        } : undefined}
        className={cn(
          'relative flex w-full items-center transition-colors duration-150',
          expanded
            ? cn('gap-3 py-2 rounded-xl', isSubItem ? 'px-3 pl-7' : 'px-3')
            : isActive
              ? 'justify-center px-0 py-2.5 rounded-l-[20px] rounded-r-none'
              : 'justify-center px-0 py-2.5 rounded-xl',
          isActive
            ? 'bg-[#141928] text-white'
            : expanded
              ? 'text-gray-600 hover:bg-black/[0.06] hover:text-gray-900'
              : 'text-gray-400 hover:bg-black/[0.06] hover:text-gray-700'
        )}
      >
        {isActive && expanded && (
          <span className="absolute left-0 top-1/2 -translate-y-1/2 w-[3px] h-5 bg-primary rounded-r-full" />
        )}

        <item.icon className={cn(
          'shrink-0 transition-colors',
          expanded ? 'h-4 w-4' : 'h-5 w-5',
          isActive ? 'text-primary' : ''
        )} />

        <span
          style={{
            opacity: expanded ? 1 : 0,
            maxWidth: expanded ? 140 : 0,
            overflow: 'hidden',
            whiteSpace: 'nowrap',
            transition: `opacity 0.22s ${delay}s, max-width 0.3s`,
          }}
          className="text-[11px] font-semibold tracking-wide"
        >
          {item.name}
        </span>

        {isActive && expanded && (
          <ChevronRight className="ml-auto h-3 w-3 opacity-40 flex-shrink-0" />
        )}
      </button>
    )
  }

  return (
    <>
      {/* Mobile backdrop */}
      {sidebarOpen && (
        <div
          className="fixed inset-0 z-40 bg-black/60 backdrop-blur-sm md:hidden"
          onClick={() => setSidebarOpen(false)}
        />
      )}

      <aside
        onMouseEnter={() => setHovered(true)}
        onMouseLeave={() => setHovered(false)}
        style={{
          width: expanded ? 220 : 58,
          background: 'rgba(245,246,250,0.98)',
          boxShadow: expanded
            ? '0 12px 48px rgba(0,0,0,0.18), 0 2px 8px rgba(0,0,0,0.08)'
            : '0 4px 24px rgba(0,0,0,0.10)',
        }}
        className={cn(
          'fixed left-4 top-1/2 -translate-y-1/2 z-50',
          'flex flex-col overflow-hidden rounded-[28px]',
          'backdrop-blur-xl',
          'transition-[width,background,box-shadow] duration-300 ease-[cubic-bezier(0.4,0,0.2,1)]',
          'max-h-[90vh]',
          sidebarOpen
            ? 'translate-x-0'
            : '-translate-x-[calc(100%+2rem)] md:translate-x-0'
        )}
      >

        {/* ── Logo header ── */}
        <div className={cn(
          'flex shrink-0 items-center border-b transition-all duration-300',
          expanded
            ? 'justify-between px-4 py-3 border-black/[0.07]'
            : 'justify-center px-0 py-3 border-black/[0.07]'
        )}>
          <div className="flex items-center gap-2.5 overflow-hidden">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src="/image/lopbukicon.png"
              alt="Lopbuk"
              width={30}
              height={30}
              className="rounded-lg shrink-0"
            />
            <span
              style={{
                opacity: expanded ? 1 : 0,
                maxWidth: expanded ? 130 : 0,
                overflow: 'hidden',
                whiteSpace: 'nowrap',
                transition: 'opacity 0.25s, max-width 0.3s',
              }}
              className="text-sm font-bold text-gray-800 tracking-tight"
            >
              Lopbuk
            </span>
          </div>

          {/* Mobile close */}
          <button
            onClick={() => setSidebarOpen(false)}
            style={{
              opacity: expanded ? 1 : 0,
              pointerEvents: expanded ? 'auto' : 'none',
              transition: 'opacity 0.2s',
            }}
            className="md:hidden flex items-center justify-center rounded-md h-7 w-7 text-gray-400 hover:text-gray-700 hover:bg-black/5 transition-colors"
          >
            <X className="h-4 w-4" />
          </button>
        </div>

        {/* ── Navigation ── */}
        <nav
          style={{ scrollbarWidth: 'none' }}
          className={cn(
            'flex-1 py-2 px-1.5 space-y-0.5 [&::-webkit-scrollbar]:hidden',
            expanded ? 'overflow-y-auto' : 'overflow-hidden'
          )}
        >
          {groups.map(group => {
            const items = filteredNavigation.filter(i => i.group === group.key)
            if (items.length === 0) return null

            const globalIdx = filteredNavigation.indexOf(items[0])

            return (
              <div key={group.key} className="mb-0.5">

                {/* Group label */}
                {group.label && (
                  <div
                    style={{
                      opacity: expanded ? 1 : 0,
                      maxHeight: expanded ? 32 : 0,
                      overflow: 'hidden',
                      transition: 'opacity 0.2s, max-height 0.3s',
                    }}
                  >
                    <p className="px-3 py-1 text-[9px] font-bold uppercase tracking-[0.18em] text-gray-400 select-none">
                      {group.label}
                    </p>
                  </div>
                )}

                {/* Divider when collapsed */}
                {group.label && !expanded && (
                  <div className="mx-2 my-1.5 border-t border-black/[0.07]" />
                )}

                {items.map((item, localIdx) => {
                  const delay = (globalIdx + localIdx) * 0.018

                  // ── Tienda group ──
                  if (item.id === 'tienda-group') {
                    const isGroupActive = storeGroupActive

                    return (
                      <div key="tienda-group">
                        {/* Parent button */}
                        <button
                          onClick={() => {
                            if (expanded) {
                              setStoreOpen(prev => !prev)
                            } else {
                              // On collapsed, expand sidebar and open group
                              setHovered(true)
                              setStoreOpen(true)
                            }
                          }}
                          title={!expanded ? 'Tienda' : undefined}
                          style={!expanded && isGroupActive ? {
                            marginRight: '-12px',
                            boxShadow: '0 4px 20px rgba(0,0,0,0.18)',
                          } : undefined}
                          className={cn(
                            'relative flex w-full items-center transition-colors duration-150',
                            expanded
                              ? 'gap-3 px-3 py-2.5 rounded-xl'
                              : isGroupActive
                                ? 'justify-center px-0 py-2.5 rounded-l-[20px] rounded-r-none'
                                : 'justify-center px-0 py-2.5 rounded-xl',
                            isGroupActive
                              ? 'bg-[#141928] text-white'
                              : expanded
                                ? 'text-gray-600 hover:bg-black/[0.06] hover:text-gray-900'
                                : 'text-gray-400 hover:bg-black/[0.06] hover:text-gray-700'
                          )}
                        >
                          <Store className={cn(
                            'shrink-0 transition-colors',
                            expanded ? 'h-4 w-4' : 'h-5 w-5',
                            isGroupActive ? 'text-primary' : ''
                          )} />

                          <span
                            style={{
                              opacity: expanded ? 1 : 0,
                              maxWidth: expanded ? 120 : 0,
                              overflow: 'hidden',
                              whiteSpace: 'nowrap',
                              transition: `opacity 0.22s ${delay}s, max-width 0.3s`,
                            }}
                            className="text-[11px] font-semibold tracking-wide"
                          >
                            Tienda
                          </span>

                          {/* Chevron toggle — only when expanded, absolutely positioned to not affect icon centering */}
                          {expanded && (
                            <span className="ml-auto flex-shrink-0">
                              <ChevronDown className={cn(
                                'h-3 w-3 transition-transform duration-200',
                                isGroupActive ? 'opacity-60' : 'opacity-40',
                                storeOpen ? 'rotate-0' : '-rotate-90'
                              )} />
                            </span>
                          )}
                        </button>

                        {/* Sub-items */}
                        <div
                          style={{
                            maxHeight: expanded && storeOpen ? filteredStoreSubItems.length * 44 : 0,
                            overflow: 'hidden',
                            transition: 'max-height 0.25s ease-in-out',
                          }}
                        >
                          <div className="mt-0.5 space-y-0.5">
                            {filteredStoreSubItems.map((sub, subIdx) =>
                              renderNavButton(sub, (globalIdx + localIdx + subIdx + 1) * 0.018, true)
                            )}
                          </div>
                        </div>
                      </div>
                    )
                  }

                  // ── Regular item ──
                  return renderNavButton(item, delay)
                })}
              </div>
            )
          })}
        </nav>

        {/* ── Footer ── */}
        <div className={cn(
          'shrink-0 border-t transition-all duration-300 space-y-1.5',
          expanded ? 'p-3 border-black/[0.07]' : 'p-1.5 border-black/[0.07]'
        )}>

          {/* User row */}
          <div className={cn('flex items-center overflow-hidden', expanded ? 'gap-2.5 px-1' : 'justify-center')}>
            <div className={cn(
              'flex shrink-0 items-center justify-center rounded-full text-xs font-bold transition-colors',
              'h-7 w-7 bg-primary/15 text-primary'
            )}>
              {user?.name?.charAt(0).toUpperCase() ?? '?'}
            </div>
            <div
              style={{
                opacity: expanded ? 1 : 0,
                maxWidth: expanded ? 140 : 0,
                overflow: 'hidden',
                transition: 'opacity 0.2s 0.1s, max-width 0.3s',
              }}
              className="flex-1 min-w-0"
            >
              <p className="text-xs font-semibold text-gray-800 truncate">{user?.name ?? '—'}</p>
              <p className="text-[10px] text-gray-400 truncate">{user?.email ?? ''}</p>
            </div>
          </div>

          {/* Role badge */}
          <div
            style={{
              opacity: expanded ? 1 : 0,
              maxHeight: expanded ? 40 : 0,
              overflow: 'hidden',
              transition: 'opacity 0.2s 0.12s, max-height 0.3s',
            }}
          >
            <div className={cn('mx-1 rounded-md border px-2 py-1 text-[9px] font-bold uppercase tracking-[0.15em] text-center', roleColor)}>
              {roleLabel}
            </div>
          </div>

          {/* Logout */}
          <button
            onClick={logout}
            title={!expanded ? 'Cerrar sesión' : undefined}
            className={cn(
              'flex w-full items-center rounded-xl text-xs transition-colors',
              expanded
                ? 'gap-2 px-3 py-1.5 text-gray-500 hover:bg-red-50 hover:text-red-500'
                : 'justify-center py-2 text-gray-400 hover:bg-red-50 hover:text-red-500'
            )}
          >
            <LogOut className={cn('shrink-0', expanded ? 'h-3.5 w-3.5' : 'h-4 w-4')} />
            <span
              style={{
                opacity: expanded ? 1 : 0,
                maxWidth: expanded ? 120 : 0,
                overflow: 'hidden',
                whiteSpace: 'nowrap',
                transition: 'opacity 0.2s 0.14s, max-width 0.3s',
              }}
            >
              Cerrar sesión
            </span>
          </button>
        </div>
      </aside>
    </>
  )
}
