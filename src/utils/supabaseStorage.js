import fs from 'fs/promises';
import path from 'path';

const getSupabaseConfig = () => {
  const url = (process.env.SUPABASE_URL || process.env.VITE_SUPABASE_URL || '').replace(/\/+$/, '');
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.SUPABASE_ANON_KEY || process.env.VITE_SUPABASE_PUBLISHABLE_DEFAULT_KEY || '';
  const bucket = process.env.SUPABASE_STORAGE_BUCKET || 'uploads';

  if (!url || !key) return null;
  return { url, key, bucket };
};

export const isSupabaseStorageConfigured = () => Boolean(getSupabaseConfig());

export const uploadFileToSupabase = async (filePath, objectPath, contentType = 'application/octet-stream') => {
  const config = getSupabaseConfig();
  if (!config) {
    throw new Error('Supabase storage is not configured');
  }

  const normalizedObjectPath = objectPath.replace(/\\/g, '/').replace(/^\/+/, '');
  const fileBuffer = await fs.readFile(filePath);
  const uploadUrl = `${config.url}/storage/v1/object/${config.bucket}/${encodeURI(normalizedObjectPath)}`;

  const response = await fetch(uploadUrl, {
    method: 'POST',
    headers: {
      apikey: config.key,
      Authorization: `Bearer ${config.key}`,
      'Content-Type': contentType,
      'Cache-Control': '31536000',
      'x-upsert': 'true',
    },
    body: fileBuffer,
  });

  if (!response.ok) {
    const errorText = await response.text().catch(() => '');
    throw new Error(`Supabase upload failed (${response.status}): ${errorText || response.statusText}`);
  }

  return `${config.url}/storage/v1/object/public/${config.bucket}/${normalizedObjectPath}`;
};

export const deleteFileFromSupabaseUrl = async (publicUrl) => {
  const config = getSupabaseConfig();
  if (!config || !publicUrl) return false;

  const marker = `/storage/v1/object/public/${config.bucket}/`;
  const markerIndex = publicUrl.indexOf(marker);
  if (markerIndex === -1) return false;

  const objectPath = decodeURIComponent(publicUrl.slice(markerIndex + marker.length).split('?')[0]);
  const deleteUrl = `${config.url}/storage/v1/object/${config.bucket}`;

  const response = await fetch(deleteUrl, {
    method: 'DELETE',
    headers: {
      apikey: config.key,
      Authorization: `Bearer ${config.key}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ prefixes: [objectPath] }),
  });

  return response.ok;
};

export const buildStorageObjectPath = (folder, filename) =>
  path.posix.join(folder || 'products', filename).replace(/^\/+/, '');
