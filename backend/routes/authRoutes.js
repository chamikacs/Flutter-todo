import express from "express";
import { requireAuth } from "../middleware/AuthMiddleWare.js";
import {
  SignupUser,
  LoginUser,
  GetUserProfile,
} from "../controllers/authController.js";


const authRouter = express.Router();


authRouter.post("/signup", async (req, res) => {
  await SignupUser(req, res);
});

authRouter.post("/login", async (req, res) => {
  await LoginUser(req, res);
});

authRouter.get("/:id", requireAuth, async (req, res) => {
  await GetUserProfile(req, res);
});

export default authRouter;
