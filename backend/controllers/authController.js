import { User } from "../models/User.js";
import jwt from "jsonwebtoken";
import bcrypt from "bcryptjs";

const generateToken = (user) => {
  return jwt.sign({ id: user._id, email: user.email }, process.env.SECRET, {
    expiresIn: "1d",
  });
};

export const SignupUser = async (req, res) => {
  const { name, email, password } = req.body;
  try {
    const user = await User.signup(name, email, password);

    const token = generateToken(user);

    return res
      .status(200)
      .send({ message: "User created successfully", user: user, token: token });
  } catch (error) {
    console.log(error.message)
    res.status(400).json({ error: error.message });
  }
};

export const LoginUser = async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await User.login(email, password);

    const token = generateToken(user);

    return res.status(200).send({
      message: "User logged in successfully",
      user: user,
      token: token,
    });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

export const GetUserProfile = async (req, res) => {
  const { id } = req.params;
  try {
    const user = await User.findById(id);

    if (!user) {
      return res.status(404).send({ message: `Cannot find user for ${id}` });
    }

    return res.status(200).json(user);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

export const ChangePassword = async (req, res) => {
  const { id } = req.params;
  const { newPassword } = req.body;

  try {
    const user = await User.findById(id);

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    const salt = await bcrypt.genSalt(10);
    const hash = await bcrypt.hash(newPassword, salt);

    user.password = hash;
    await user.save();

    return res.status(200).json(user);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};
