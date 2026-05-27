import prisma from '../utils/prisma.js';
import { normalizeString, validateEmailFormat, validatePhoneFormat, validatePincodeFormat } from '../utils/validation.js';
import { checkPincodeServiceability } from '../services/logisticsService.js';

/**
 * Address Controller - Handles server-side validation and storage.
 */

export const validateAddress = async (req, res) => {
  try {
    const { 
      email, 
      name, 
      phone, 
      addressLine1, 
      addressLine2, 
      city, 
      state, 
      pincode 
    } = req.body;

    const errors = {};

    // 1. Basic Format Validation
    if (!validateEmailFormat(email)) errors.email = 'Invalid email address.';
    if (!name || name.trim().length < 3) errors.name = 'Name must be at least 3 characters.';
    if (!validatePhoneFormat(phone)) errors.phone = 'Invalid phone number (6-9 followed by 9 digits).';
    if (!addressLine1 || addressLine1.trim().length < 10) errors.addressLine1 = 'Address must be at least 10 characters.';
    if (!city) errors.city = 'City is required.';
    if (!state) errors.state = 'State is required.';
    if (!validatePincodeFormat(pincode)) errors.pincode = 'Invalid pincode format.';

    if (Object.keys(errors).length > 0) {
      return res.status(400).json({ success: false, errors });
    }

    // 2. Logistics Serviceability Check
    const serviceability = await checkPincodeServiceability(pincode);
    if (!serviceability.success) {
      return res.status(400).json({ 
        success: false, 
        errors: { pincode: serviceability.message || 'Pincode not serviceable.' } 
      });
    }

    // 3. Normalization (Internal use)
    const normalizedCity = normalizeString(city);
    const normalizedState = normalizeString(state);

    res.json({ 
      success: true, 
      message: 'Address validated successfully.',
      normalized: { city: normalizedCity, state: normalizedState }
    });

  } catch (error) {
    console.error('Validate Address Error:', error.message);
    res.status(500).json({ success: false, message: 'Server error during validation.' });
  }
};

export const saveAddress = async (req, res) => {
  try {
    const { id: customerId } = req.user; // Assuming auth middleware
    const { 
      name, 
      firstName, 
      lastName, 
      phone, 
      address, 
      addressLine1, 
      apartment, 
      addressLine2, 
      city, 
      state, 
      pinCode, 
      pincode 
    } = req.body;

    const addressToSave = {
      customerId,
      name: name || `${firstName || ''} ${lastName || ''}`.trim() || 'Saved Address',
      phone: String(phone || ''),
      addressLine1: addressLine1 || address || '',
      addressLine2: addressLine2 || apartment || '',
      city: normalizeString(city || ''),
      state: normalizeString(state || ''),
      pincode: String(pincode || pinCode || ''),
    };

    // Duplicate check
    const existing = await prisma.address.findFirst({
      where: {
        customerId,
        addressLine1: { equals: addressToSave.addressLine1,    },
        city: { equals: addressToSave.city,    },
        pincode: addressToSave.pincode
      }
    });

    if (existing) {
      return res.status(200).json({ success: true, message: 'Address already saved.', address: existing });
    }

    const addressResult = await prisma.address.create({
      data: addressToSave
    });

    res.status(201).json({ success: true, address: addressResult });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
