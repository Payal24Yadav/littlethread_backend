import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

dotenv.config();

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseKey) {
  console.error('Missing Supabase credentials in .env');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

async function createReviewBucket() {
  console.log('Attempting to create "reviews" bucket...');
  
  const { data, error } = await supabase.storage.createBucket('reviews', {
    public: true,
    fileSizeLimit: 1048576, // 1MB
    allowedMimeTypes: ['image/jpeg', 'image/png', 'image/webp']
  });

  if (error) {
    if (error.message.includes('already exists')) {
      console.log('Bucket "reviews" already exists.');
    } else {
      console.error('Error creating bucket:', error);
    }
  } else {
    console.log('Bucket "reviews" created successfully:', data);
  }
}

createReviewBucket();
