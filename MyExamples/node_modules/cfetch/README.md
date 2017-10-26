# cfetch

A common configuration of fetch.

Install:

```
$ npm install cfetch
```

Example:

```js
const cfetch = require('cfetch');
cfetch('http://localhost:3000')('GET')('/')().then(console.log);
```
