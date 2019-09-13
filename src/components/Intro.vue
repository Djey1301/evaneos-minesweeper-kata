<script>
export default {
    name: 'Intro',
    data() {
        return {
            speech: '',
            speeches: [
                'Ha enfin te voila la bleusaille !<br/>Ici le Sergent Evaneos, bon tu débarques trop tard, la guerre est fini !',
                "Mais j'ai une bonne nouvelle pour toi, j'ai une mission à te confier.",
                "Pour empêcher l'ennemi de progresser on a totalement miner une petite île du pacifique.",
                "Sauf que maintenant on doit la rendre aux autochtones....<br/>T'as pigé !?",
                'Allez voilà une pelle et un détecteur de métal !<br/>Et rassures toi, ta maman recevra ta pension si tu te rates.<br/>Hahaha....',
            ],
            speechCursor: 0,
            nextButton: false,
            selectButton: false,
        };
    },
    methods: {
        reset() {
            this.speechCursor = 0;
            this.refreshContent();
        },
        next() {
            this.speechCursor++;
            this.refreshContent();
        },
        refreshContent() {
            let self = this;
            let html = this.speeches[this.speechCursor];
            this.speech = html;
            if (this.speeches[this.speechCursor + 1]) {
                this.nextButton = true;
                this.selectButton = false;
            } else {
                this.nextButton = false;
                this.selectButton = true;
            }
        },
        selectDifficulty(difficulty) {
            this.$router.push('/game/' + difficulty);
        },
    },
    mounted() {
        this.reset();
    },
};
</script>

<style scoped>
#intro {
    width: 100%;
    height: 100vmin;
    text-align: center;
}

.box {
    position: absolute;
    top: 1vmin;
    left: 30%;
    width: 40%;
    height: 150px;
    z-index: 10;
    border-top: 5px solid slategray;
    border-left: 5px solid slategray;
    border-bottom: 5px solid darkslategray;
    border-right: 5px solid darkslategray;
    background: lightgray;
}
.content {
    position: relative;
}

.text {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 140px;
    padding: 20px 100px 20px 20px;
    font-size: 1em;
    overflow-x: hidden;
    overflow-y: scroll;
}

.buttons {
    margin: 20px 0;
    text-align: center;
}

.buttons button {
    border-top: 2px solid slategray;
    border-left: 2px solid slategray;
    border-bottom: 2px solid darkslategray;
    border-right: 2px solid darkslategray;
    font-size: 1em;
    cursor: pointer;
}

.portrait {
    position: absolute;
    top: 0;
    right: 0;
    width: 100px;
    height: 140px;
    padding-top: 100px;
    background: white url('../assets/sergent.jpeg') no-repeat;
    background-size: contain;
    border-left: 3px solid darkslategray;
    font-size: 16px;
}

#island {
    position: relative;
    top: 30vmin;
    width: 60vmin;
    height: 60vmin;
    margin: 0 auto;
    background: url('../assets/island.png') no-repeat;
    background-size: contain;
}
</style>

<template>
    <div id="intro">
        <div id="dialog">
            <div class="box">
                <div class="content">
                    <div class="text">
                        <div v-html="speech"></div>
                        <div class="buttons">
                            <button type="button" v-on:click="next()" v-show="nextButton">Suivant</button>
                            <button
                                type="button"
                                v-on:click="selectDifficulty('easy')"
                                v-show="selectButton"
                            >Facile</button>
                            <button
                                type="button"
                                v-on:click="selectDifficulty('medium')"
                                v-show="selectButton"
                            >Moyen</button>
                            <button
                                v-on:click="selectDifficulty('hard')"
                                v-show="selectButton"
                            >Difficile</button>
                        </div>
                    </div>
                    <div class="portrait">Sergent Evaneos</div>
                </div>
            </div>
        </div>
        <div id="island"></div>
    </div>
</template>