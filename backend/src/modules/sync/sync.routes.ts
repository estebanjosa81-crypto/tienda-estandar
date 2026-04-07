import { Router } from 'express';
import {
  getStatus, triggerSync, getChanges,
  receiveSales, receivePurchases,
  receiveCustomers, receiveProducts, receiveMovements,
  receiveCashSessions, receiveCreditPayments, receiveCategories,
  receiveOrders, receiveRecipes, receiveSuppliers,
} from './sync.controller';
import { authenticate } from '../../common/middleware';

const router = Router();

// Estado del sync (online/offline, pendientes) — usado por el frontend
router.get('/status', authenticate, getStatus);

// Disparar sync manual
router.post('/trigger', authenticate, triggerSync);

// Endpoint de la NUBE: sirve cambios incrementales a las instancias locales (PULL)
router.get('/changes', getChanges);

// Endpoints que usa el backend LOCAL para enviar datos a la NUBE (PUSH)
router.post('/receive-sales',           receiveSales);
router.post('/receive-purchases',       receivePurchases);
router.post('/receive-customers',       receiveCustomers);
router.post('/receive-products',        receiveProducts);
router.post('/receive-movements',       receiveMovements);
router.post('/receive-cash-sessions',   receiveCashSessions);
router.post('/receive-credit-payments', receiveCreditPayments);
router.post('/receive-categories',      receiveCategories);
router.post('/receive-orders',          receiveOrders);
router.post('/receive-recipes',         receiveRecipes);
router.post('/receive-suppliers',       receiveSuppliers);

export { router as syncRoutes };
