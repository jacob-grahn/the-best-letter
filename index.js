const Koa = require('koa')
const app = new Koa()

// response
app.use(ctx => {
  ctx.body = 'The best letter is... "Q"'
})

app.listen(8080)
