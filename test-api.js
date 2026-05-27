import http from 'http';

http.get('http://localhost:5000/api/products/92a7ec39-57ba-4bab-b955-4d6297affe9e', (res) => {
  let data = '';
  res.on('data', chunk => { data += chunk; });
  res.on('end', () => {
    console.log(`Status: ${res.statusCode}`);
    if (res.statusCode !== 200) console.log(data);
  });
}).on('error', err => console.log('Error:', err.message));
