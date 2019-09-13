<script>
import Grid from '@/components/Grid';
import Score from '@/components/Score';

export default {
    name: 'Gameboard',
    data() {
        return {
            difficulty: 'medium',
            size: 18,
            mines: 30,
            score: 0,
            gameState: '',
            modal: false,
            speech: '',
            speechesWon: [
                'Un boulot impecable !<br/>Les autochtones vont pouvoir revenir sur leur île.',
                "Bon allez, y'a encore d'autres îles<br/>Choisi ton niveau.",
            ],
            speechesLose: [
                "Tu t'es fait explosé !<br/>Heureusement qu'on a appris à cloner.<br/>Allez au boulot !",
                'Allez renvoie ton nouveau cul de clône sur le terrain !<br/>Tu te sens quel niveau ?',
            ],
            speechCursor: 0,
            nextButton: false,
            selectButton: false,
        };
    },
    watch: {
        difficulty: 'reset',
    },
    components: {
        Grid,
        Score,
    },
    methods: {
        reset() {
            this.gameState = '';
            this.modal = false;
            this.speechCursor = 0;
            this.nextButton = false;
            this.selectButton = false;
            this.score = 0;
            switch (this.difficulty) {
                case 'easy':
                    this.size = 15;
                    this.mine = 20;
                    break;
                case 'medium':
                    this.size = 18;
                    this.mine = 30;
                    break;
                case 'hard':
                    this.size = 18;
                    this.mine = 50;
                    break;
            }
            this.$refs.gridComponent.reset();
            this.$refs.scoreComponent.reset();
        },
        handleAGameChange(event) {
            switch (event.type) {
                case 'game':
                    if (event.data === 'win') {
                        this.gameState = 'win';
                    } else {
                        this.gameState = 'lost';
                    }
                    this.modal = true;
                    this.speechCursor = 0;
                    this.refreshContent();
                    break;
                case 'score':
                    if (event.data === 'max') {
                        this.score = event.score;
                    } else {
                        this.score += event.score;
                        if (this.score < 0) {
                            this.score = 0;
                        }
                    }
                    break;
            }
        },
        next() {
            this.speechCursor++;
            this.refreshContent();
        },
        undo() {
            this.$refs.gridComponent.undo();
            this.gameState = '';
            this.modal = false;
            this.speechCursor = 0;
            this.nextButton = false;
            this.selectButton = false;
        },
        refreshContent() {
            let html;
            switch (this.gameState) {
                case 'win':
                    html = this.speechesWon[this.speechCursor];
                    this.speech = html;
                    if (this.speechesWon[this.speechCursor + 1]) {
                        this.nextButton = true;
                        this.selectButton = false;
                    } else {
                        this.nextButton = false;
                        this.selectButton = true;
                    }
                    break;
                case 'lost':
                    html = this.speechesLose[this.speechCursor];
                    this.speech = html;
                    if (this.speechesLose[this.speechCursor + 1]) {
                        this.nextButton = true;
                        this.selectButton = false;
                    } else {
                        this.nextButton = false;
                        this.selectButton = true;
                    }
                    break;
            }
        },
        selectDifficulty(difficulty) {
            if (this.difficulty !== difficulty) {
                this.difficulty = difficulty;
            }
            this.reset();
        },
    },
    mounted() {
        this.difficulty = this.$route.params.difficulty;
        this.reset();
    },
};
</script>

<style scoped>
#gameboard {
    width: 100%;
    height: 96vmin;
    padding: 0 5%;
}

#modal {
    width: 100%;
    height: 0;
    overflow: visible;
    text-align: center;
}

.box {
    position: absolute;
    top: 40vmin;
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
</style>

<template>
    <div id="gameboard">
        <Grid
            ref="gridComponent"
            @interface="handleAGameChange"
            v-bind:size="this.size"
            v-bind:mines="this.mines"
            v-bind:gameState="this.gameState"
        />
        <Score
            ref="scoreComponent"
            @interface="handleAGameChange"
            v-bind:score="score"
            v-bind:gameState="this.gameState"
        />
        <div id="modal" v-show="modal">
            <div id="dialog">
                <div class="box">
                    <div class="content">
                        <div class="text">
                            <div v-html="speech"></div>
                            <div class="buttons">
                                <button
                                    type="button"
                                    v-on:click="next()"
                                    v-show="nextButton"
                                >Suivant</button>
                                <button
                                    type="button"
                                    v-on:click="undo()"
                                    v-show="nextButton && gameState==='lost'"
                                >Annuler la dernière action (-5pts)</button>
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
        </div>
    </div>
</template>