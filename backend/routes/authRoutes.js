import express from "express";
import { requireAuth } from "../middleware/AuthMiddleWare.js";
import {
  SignupUser,
  LoginUser,
  GetUserProfile,
  ChangePassword,
} from "../controllers/authController.js";


const authRouter = express.Router();


authRouter.post("/signup", SignupUser);

authRouter.post("/login", LoginUser);

authRouter.get("/:id", requireAuth, GetUserProfile);

authRouter.post("/:id", requireAuth, ChangePassword)

export default authRouter;
