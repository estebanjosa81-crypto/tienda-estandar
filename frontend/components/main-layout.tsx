'use client'

import React from "react"
import { useStore } from "@/lib/store"
import { Sidebar } from './sidebar'
import { Header } from './header'

interface MainLayoutProps {
  children: React.ReactNode
}

export function MainLayout({ children }: MainLayoutProps) {
  const { sidebarCollapsed } = useStore()

  return (
    <div className="min-h-screen bg-background">
      <Sidebar />
      <div className={sidebarCollapsed ? "md:pl-14" : "md:pl-60"} style={{ transition: 'padding-left 300ms ease-in-out' }}>
        <Header />
        <main className="p-4 sm:p-6 lg:p-8 xl:p-10 max-w-[1920px] mx-auto">
          {children}
        </main>
      </div>
    </div>
  )
}
