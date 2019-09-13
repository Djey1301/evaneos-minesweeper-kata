<template>
    <div id="app">
        <router-view />
    </div>
</template>

<script>
export default {
    name: 'App',
};
</script>

<style>
html,
body {
    width: 100%;
    margin: 0;
    padding: 0;
    font-family: 'Avenir', Helvetica, Arial, sans-serif;
    font-size: 2vh;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    background: url('./assets/water.png') repeat;
}

a {
    color: #42b983;
}

div {
    box-sizing: border-box;
}

#app {
    height: 100vh;
    width: 100%;
    margin: 0;
    padding: 0;
}
</style>
