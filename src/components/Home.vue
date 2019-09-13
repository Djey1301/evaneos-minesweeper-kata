<template>
    <div id="home">
        <h1>Test de Jerome ARNOULT pour l'embauche chez Evaneos</h1>
        <p>
            Si vous lisez ceci, vous avez réussi à installer et faire fonctionner mon application.<br/>
            Je n'ai pas souhaité utiliser ReactJS étant encore trop faible sur cette technologie.</br>
            J'ai donc utiliser ce que je connais de VueJS et même plus.</br>
            J'ai passé 2 jours sur votre test, mais je voulais le faire vraiment bien<br/>
            De plus j'ai essayé de mettre en application des pistes d'améliorations que d'autres boites m'ont suggéré, comme revoir mon architecture logiciel etc...<br/>
            J'espère que le résultat vous impresionnera et vous convaincra de ma capacité à rejoindre votre équipe.<br/>
            <br/>
            Bonne amusement à vous !<br/>
        </p>
        <router-link tag="button" :to="{path:'/game'}">Lancer la partie</router-link>
    </div>
</template>

<script>
export default {
    name: 'Home',
    data() {
        return {};
    },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
#home{
    position:absolute;
    width:50%;
    height:50vmin;
    top:25vmin; left: 25%;
    font-size:1em;
    background:white;
}

h1{
    width:100%;
    margin:0;
    padding:10px;
}

p{
    padding:20px;
}

button{
    display:inline-block;
    margin:0 auto;
}
</style>
