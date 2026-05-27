import express from 'express';
import { submitMessage, getMessages, deleteMessage, toggleRead } from '../controllers/contactController.js';

const router = express.Router();

router.post('/', submitMessage);
router.get('/', getMessages);
router.delete('/:id', deleteMessage);
router.patch('/:id/read', toggleRead);

export default router;
