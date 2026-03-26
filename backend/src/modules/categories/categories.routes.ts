import { Router } from 'express';
import { body, param } from 'express-validator';
import { categoriesController } from './categories.controller';
import { authenticate } from '../../common/middleware';
import { validateRequest } from '../../utils/validators';

const router: ReturnType<typeof Router> = Router();

router.use(authenticate);

// GET /api/categories
router.get('/', categoriesController.findAll.bind(categoriesController));

// POST /api/categories
router.post(
  '/',
  [
    body('id').notEmpty().withMessage('El identificador es requerido'),
    body('name').notEmpty().withMessage('El nombre es requerido'),
    body('description').optional().isString(),
    validateRequest,
  ],
  categoriesController.create.bind(categoriesController)
);

// PUT /api/categories/:id
router.put(
  '/:id',
  [
    param('id').notEmpty().withMessage('ID requerido'),
    body('name').optional().isString().notEmpty().withMessage('El nombre no puede estar vacío'),
    body('description').optional().isString(),
    body('isHidden').optional().isBoolean(),
    validateRequest,
  ],
  categoriesController.update.bind(categoriesController)
);

// DELETE /api/categories/:id
router.delete(
  '/:id',
  [param('id').notEmpty().withMessage('ID requerido'), validateRequest],
  categoriesController.delete.bind(categoriesController)
);

export default router;
