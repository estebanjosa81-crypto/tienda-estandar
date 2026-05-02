import React from "react"
import type { Metadata } from 'next'
import { ThemeProvider } from 'next-themes'
import { Toaster } from 'sonner'
import { GoogleOAuthWrapper } from '@/components/google-oauth-wrapper'
import { DynamicFavicon } from '@/components/dynamic-favicon'
import { Cormorant_Garamond } from 'next/font/google'
import './globals.css'

const cormorant = Cormorant_Garamond({
  subsets: ['latin'],
  weight: ['300', '400', '500', '600', '700'],
  style: ['normal', 'italic'],
  variable: '--font-cormorant',
  display: 'swap',
})


export const metadata: Metadata = {
  title: 'perfum mua - !Bienvenido a la mejor perfumeria de colombia!',
  description: '',
  generator: 'v0.app',
  icons: {
    icon: '/faviconbeso.png',
    apple: '/faviconbeso.png',
    shortcut: '/faviconbeso.png',
  },
}

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode
}>) {
  return (
    <html lang="es" suppressHydrationWarning>
      <body className={`${cormorant.variable} font-sans antialiased`}>
        <ThemeProvider attribute="class" defaultTheme="dark" enableSystem={false}>
          <DynamicFavicon />
          <GoogleOAuthWrapper>
            {children}
          </GoogleOAuthWrapper>
          <Toaster richColors position="top-center" />
        </ThemeProvider>
      </body>
    </html>
  )
}
