import express from "express";
import uploadLocal from "../middleware/uploadLocal.js";
import { uploadImage, deleteImage } from "../controllers/uploadController.js";

const router = express.Router();

router.post("/", uploadLocal.single("image"), uploadImage);
router.delete("/", deleteImage);

export default router;
