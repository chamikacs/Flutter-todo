import jwt from "jsonwebtoken";

export const requireAuth = async (req, res, next) => {
  try {
    const token = req.header("Authorization").replace("Bearer ", "");

    if (!token) {
      return res.status(401).send({ message: "Authorization token required" });
    }

    // console.log("Authorization header:", token);

    if (!token) {
      return res.status(401).send({ message: "JWT must be provided" });
    }

    const decoded = jwt.verify(token, process.env.SECRET);
    // console.log(decoded)
    req.user = decoded;
    // console.log(req.user)
    next();
  } catch (error) {
    console.error("JWT verification error:", error);
    res.status(401).send({ message: error.message });
  }
};
