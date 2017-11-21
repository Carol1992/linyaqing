<template>
  <div id="app">
    <div class="myheader">
      <LHeader></LHeader>
    </div>
    <router-view :key="key"/>
  </div>
</template>

<script>
import LHeader from './components/LHeader'
export default {
  name: 'app',
  components: {
    LHeader
  },
  data () {
    return {}
  },
  computed: {
    key () {
      return this.$route.name !== undefined ? this.$route.name + +new Date() : this.$route + +new Date()
    }
  },
  mounted () {
    var ws = new WebSocket('ws://localhost:3001')
    ws.onopen = function (evt) {
      console.log('Connection open ...')
      ws.send('hi')
    }
    ws.onmessage = function (evt) {
      console.log(JSON.parse(evt.data))
      ws.close()
    }
    ws.onclose = function (evt) {
      console.log('Connection closed.')
    }
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #111;
  margin-bottom: 30px;
}
.myheader {
  padding-top: 1%;
  padding-bottom: 1%;
  background-color: #fff;
  position: fixed;
  width: 100%;
  top: 0;
  z-index: 2;
}
</style>
