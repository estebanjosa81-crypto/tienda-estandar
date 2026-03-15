import { Router } from 'express';
import { getStatus, triggerSync, receiveSales, receivePurchases } from './sync.controller';
import { authenticate } from '../../common/middleware';

const router = Router();

// Estado del sync (online/offline, pendientes) — usado por el frontend
router.get('/status', authenticate, getStatus);

// Disparar sync manual
router.post('/trigger', authenticate, triggerSync);

// Endpoints que usa el backend LOCAL para enviar datos a la NUBE
router.post('/receive-sales', receiveSales);
router.post('/receive-purchases', receivePurchases);

export { router as syncRoutes };
