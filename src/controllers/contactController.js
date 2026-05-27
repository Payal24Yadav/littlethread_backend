import prisma from '../utils/prisma.js';

export const submitMessage = async (req, res) => {
  try {
    const { name, email, subject, message } = req.body;
    const newMessage = await prisma.contactMessage.create({
      data: { name, email, subject, message }
    });
    res.json(newMessage);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const getMessages = async (req, res) => {
  try {
    const messages = await prisma.contactMessage.findMany({
      orderBy: { createdAt: 'desc' }
    });
    res.json(messages);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const deleteMessage = async (req, res) => {
  try {
    await prisma.contactMessage.delete({ where: { id: req.params.id } });
    res.json({ success: true });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const toggleRead = async (req, res) => {
  try {
    const msg = await prisma.contactMessage.findUnique({ where: { id: req.params.id } });
    if (!msg) return res.status(404).json({ message: 'Not found' });
    const updated = await prisma.contactMessage.update({
      where: { id: req.params.id },
      data: { isRead: !msg.isRead }
    });
    res.json(updated);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
