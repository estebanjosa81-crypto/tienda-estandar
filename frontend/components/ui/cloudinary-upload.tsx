'use client'

import { useRef, useState } from 'react'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Upload, X, Loader2, Image as ImageIcon } from 'lucide-react'

interface CloudinaryUploadProps {
  value: string
  onChange: (url: string) => void
  label?: string
  previewClassName?: string
  accept?: string
}

/** Lee las credenciales: localStorage tiene prioridad sobre .env.local */
function getCloudinaryConfig() {
  if (typeof window !== 'undefined') {
    const cloudName = localStorage.getItem('cloudinary_cloud_name') ||
      process.env.NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME || ''
    const uploadPreset = localStorage.getItem('cloudinary_upload_preset') ||
      process.env.NEXT_PUBLIC_CLOUDINARY_UPLOAD_PRESET || ''
    return { cloudName, uploadPreset }
  }
  return {
    cloudName: process.env.NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME || '',
    uploadPreset: process.env.NEXT_PUBLIC_CLOUDINARY_UPLOAD_PRESET || '',
  }
}

export function CloudinaryUpload({
  value,
  onChange,
  label,
  previewClassName = 'h-20 w-20 object-cover rounded-lg border',
  accept = 'image/*',
}: CloudinaryUploadProps) {
  const inputRef = useRef<HTMLInputElement>(null)
  const [uploading, setUploading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const handleFileChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (!file) return

    const { cloudName, uploadPreset } = getCloudinaryConfig()

    if (!cloudName || cloudName === 'tu_cloud_name') {
      setError('Configura el Cloud Name en Configuración → Integraciones')
      return
    }
    if (!uploadPreset || uploadPreset === 'tu_upload_preset') {
      setError('Configura el Upload Preset en Configuración → Integraciones')
      return
    }

    setError(null)
    setUploading(true)

    try {
      const formData = new FormData()
      formData.append('file', file)
      formData.append('upload_preset', uploadPreset)

      const res = await fetch(
        `https://api.cloudinary.com/v1_1/${cloudName}/image/upload`,
        { method: 'POST', body: formData }
      )

      if (!res.ok) {
        const data = await res.json()
        const msg = data?.error?.message ?? 'Error al subir la imagen'
        // 400 casi siempre = preset incorrecto o no existe
        if (res.status === 400) {
          throw new Error(`${msg} — Verifica que el Upload Preset exista y esté en modo "Unsigned" en tu cuenta de Cloudinary`)
        }
        throw new Error(msg)
      }

      const data = await res.json()
      onChange(data.secure_url)
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : 'Error al subir la imagen')
    } finally {
      setUploading(false)
      if (inputRef.current) inputRef.current.value = ''
    }
  }

  return (
    <div className="space-y-2">
      {label && <label className="text-sm font-medium mb-1 block">{label}</label>}

      <input
        ref={inputRef}
        type="file"
        accept={accept}
        className="hidden"
        onChange={handleFileChange}
      />

      <div className="flex gap-2 items-center flex-wrap">
        <Button
          type="button"
          variant="outline"
          size="sm"
          disabled={uploading}
          onClick={() => inputRef.current?.click()}
        >
          {uploading ? (
            <Loader2 className="h-4 w-4 mr-2 animate-spin" />
          ) : (
            <Upload className="h-4 w-4 mr-2" />
          )}
          {uploading ? 'Subiendo...' : 'Subir imagen'}
        </Button>

        <Input
          type="url"
          placeholder="o pega una URL"
          value={value}
          onChange={e => onChange(e.target.value)}
          className="flex-1 min-w-[180px] text-sm"
        />

        {value && (
          <Button
            type="button"
            variant="ghost"
            size="icon"
            onClick={() => onChange('')}
          >
            <X className="h-4 w-4 text-destructive" />
          </Button>
        )}
      </div>

      {error && (
        <p className="text-xs text-destructive">{error}</p>
      )}

      {value ? (
        <div className="mt-2 flex items-center gap-3">
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img
            src={value}
            alt="Vista previa"
            className={previewClassName}
            onError={e => {
              ;(e.target as HTMLImageElement).style.display = 'none'
            }}
          />
        </div>
      ) : (
        <div
          className="flex items-center justify-center border border-dashed rounded-lg h-16 text-muted-foreground/40 cursor-pointer hover:bg-muted/20 transition-colors"
          onClick={() => inputRef.current?.click()}
        >
          <ImageIcon className="h-6 w-6 mr-2" />
          <span className="text-xs">Click para seleccionar imagen</span>
        </div>
      )}
    </div>
  )
}
