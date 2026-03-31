import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export function formatCOP(value: number): string {
  return new Intl.NumberFormat('es-CO', {
    style: 'currency',
    currency: 'COP',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(value)
}

export function formatNumber(value: number): string {
  return new Intl.NumberFormat('es-CO').format(value)
}

const TZ = 'America/Bogota'

export function formatDate(date: string | Date): string {
  return new Date(date).toLocaleDateString('es-CO', { timeZone: TZ, day: '2-digit', month: '2-digit', year: 'numeric' })
}

export function formatTime(date: string | Date): string {
  return new Date(date).toLocaleTimeString('es-CO', { timeZone: TZ, hour: '2-digit', minute: '2-digit' })
}

export function formatDateTime(date: string | Date): string {
  return new Date(date).toLocaleString('es-CO', { timeZone: TZ, day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit' })
}

export function formatDateLong(date: string | Date): string {
  return new Date(date).toLocaleDateString('es-CO', { timeZone: TZ, year: 'numeric', month: 'long', day: 'numeric' })
}
