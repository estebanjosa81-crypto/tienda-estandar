import { Request, Response, NextFunction } from 'express';
import { authService } from './auth.service';
import { AuthRequest } from '../../common/middleware';

export class AuthController {
  async login(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { email, password } = req.body;
      const result = await authService.login(email, password);

      res.json({
        success: true,
        data: result,
        message: 'Inicio de sesion exitoso',
      });
    } catch (error) {
      next(error);
    }
  }

  async register(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { email, password, name, role, tenantId } = req.body;
      const result = await authService.register(email, password, name, role, tenantId);

      res.status(201).json({
        success: true,
        data: result,
        message: 'Usuario registrado exitosamente',
      });
    } catch (error) {
      next(error);
    }
  }

  async registerClient(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { email, password, name, phone, storeSlug,
              cedula, department, municipality, address, neighborhood } = req.body;
      const result = await authService.registerClient(
        email, password, name, phone, storeSlug || undefined,
        { cedula, department, municipality, address, neighborhood }
      );

      res.status(201).json({
        success: true,
        data: result,
        message: 'Cuenta de cliente creada exitosamente',
      });
    } catch (error) {
      next(error);
    }
  }

  async googleLogin(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { credential, storeSlug } = req.body;
      const result = await authService.googleLogin(credential, storeSlug || undefined);

      res.json({
        success: true,
        data: result,
        message: 'Inicio de sesion con Google exitoso',
      });
    } catch (error) {
      next(error);
    }
  }

  async getProfile(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const user = await authService.getProfile(req.user!.userId);

      res.json({
        success: true,
        data: user,
      });
    } catch (error) {
      next(error);
    }
  }

  async updateProfile(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const { name, avatar, phone, cedula, department, municipality, address, neighborhood, deliveryLatitude, deliveryLongitude } = req.body;
      const user = await authService.updateProfile(req.user!.userId, {
        name, avatar, phone, cedula, department, municipality, address, neighborhood,
        deliveryLatitude: deliveryLatitude != null ? Number(deliveryLatitude) : undefined,
        deliveryLongitude: deliveryLongitude != null ? Number(deliveryLongitude) : undefined,
      });

      res.json({
        success: true,
        data: user,
        message: 'Perfil actualizado exitosamente',
      });
    } catch (error) {
      next(error);
    }
  }

  async changePassword(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const { currentPassword, newPassword } = req.body;
      await authService.changePassword(req.user!.userId, currentPassword, newPassword);

      res.json({
        success: true,
        message: 'Contrasena actualizada exitosamente',
      });
    } catch (error) {
      next(error);
    }
  }
}

export const authController = new AuthController();
