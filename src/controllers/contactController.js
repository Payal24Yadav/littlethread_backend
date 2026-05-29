import prisma from '../utils/prisma.js';

export const submitMessage = async (req, res) => {
  try {
    const { name, email, subject, message } = req.body;
    const payload = {
      name: String(name || '').trim(),
      email: String(email || '').trim().toLowerCase(),
      subject: String(subject || 'General Inquiry').trim() || 'General Inquiry',
      message: String(message || '').trim(),
    };

    if (!payload.name || !payload.email || !payload.message) {
      return res.status(400).json({ message: 'Name, email, and message are required.' });
    }

    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(payload.email)) {
      return res.status(400).json({ message: 'Enter a valid email address.' });
    }

    const newMessage = await prisma.contactMessage.create({
      data: payload
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
