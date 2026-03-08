import path from 'node:path';
import react from '@vitejs/plugin-react';
import { defineConfig } from 'vite';

export default defineConfig({
  plugins: [react()],
  server: {
    cors: true,
    host: true,
    port: 3000,
  },
  resolve: {
    extensions: ['.jsx', '.js', '.tsx', '.ts', '.json'],
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
  build: {
    outDir: 'dist',
    rollupOptions: {
      output: {
        manualChunks(id) {
          if (id.includes('node_modules')) {
            // XLSX - büyük kütüphane
            if (id.includes('xlsx') || id.includes('sheetjs')) {
              return 'vendor-xlsx';
            }
            // jsPDF
            if (id.includes('jspdf')) {
              return 'vendor-jspdf';
            }
            // Recharts ve D3
            if (id.includes('recharts') || id.includes('d3-')) {
              return 'vendor-recharts';
            }
            // Date-fns
            if (id.includes('date-fns')) {
              return 'vendor-date';
            }
            // Supabase
            if (id.includes('@supabase')) {
              return 'vendor-supabase';
            }
            // Lucide icons
            if (id.includes('lucide-react')) {
              return 'vendor-icons';
            }
          }
        }
      }
    },
    chunkSizeWarningLimit: 800,
  }
});
