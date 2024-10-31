import express from "express";

import {
  SignupUser,
  LoginUser,
  GetUserProfile,
  ChangePassword,
} from "../controllers/authController.js";
import { requireAuth } from "../middleware/authMiddleware.js";


const authRouter = express.Router();


authRouter.post("/signup", SignupUser);

authRouter.post("/login", LoginUser);

authRouter.get("/:id", requireAuth, GetUserProfile);

authRouter.post("/:id", requireAuth, ChangePassword)

// authRouter.route("/:id").get(requireAuth, GetUserProfile).post(requireAuth, ChangePassword)

export default authRouter;
