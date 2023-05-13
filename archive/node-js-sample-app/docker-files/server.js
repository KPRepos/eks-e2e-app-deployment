const http = require('http');
const os = require('os');

// const hostname = '0.0.0.0';
const port = 80;

const server = http.createServer((req, res) => {
  if (req.url === '/') {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    const ipAddress = getServerIpAddress();
    res.end(`Hello World,  my host IP is: ${ipAddress}\n`);
  } else {
    res.statusCode = 404;
    res.setHeader('Content-Type', 'text/plain');
    res.end("404 Not Found - Sorry this path currently don't exist only root path exists for this sample app \n'");
  }
});

const ipAddress = getServerIpAddress();
server.listen(port, () => {
  console.log(`Server running at http://${ipAddress}:${port}/`);
});

function getServerIpAddress() {
  const interfaces = os.networkInterfaces();
  for (let iface in interfaces) {
    const addresses = interfaces[iface];
    for (let i = 0; i < addresses.length; i++) {
      const address = addresses[i];
      if (!address.internal && address.family === 'IPv4') {
        return address.address;
      }
    }
  }
}
