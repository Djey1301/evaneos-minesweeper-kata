<script>
import Cell from '@/components/Cell';

export default {
    name: 'Grid',
    components: {
        Cell,
    },
    props: ['size', 'mines', 'gameState'],
    watch: {
        size: 'reset',
        mines: 'reset',
    },
    data() {
        return {
            cells: [],
            cellsCopy: [],
            cellsCleaned: [],
            cellsLeft: 0,
            cellsLeftCopy: 0,
            undoIsNotPossible: true,
        };
    },
    mounted() {
        this.reset();
    },
    methods: {
        reset() {
            this.generate(this.size, this.mines);
        },
        generate(size, minesCount) {
            this.size = size;
            const length = size * size;
            let cells = [];
            this.cells = [];
            this.cellsLeft = 0;
            let index = -1;

            //On crée les cellules
            while (++index < length) {
                let cell = {
                    status: 'untouched',
                    badNeighbors: 0,
                    bomb: minesCount > index,
                    size: this.size,
                };
                cells.push(cell);
            }

            // On les mélange
            index = -1;
            while (++index < length) {
                let rand = index + Math.floor(Math.random() * (length - index));
                let cell = cells[rand];

                cells[rand] = cells[index];
                cells[index] = cell;
            }
            this.cells = cells;

            // On les mets à jour (voisins + condition victoire)
            index = -1;
            while (++index < length) {
                if (!this.cells[index].bomb) {
                    this.cellsLeft++;
                }
                this.calculBadNeighbors(index);
            }

            // On envoie le score max
            this.$emit('interface', {
                type: 'score',
                data: 'max',
                score: this.cellsLeft,
            });
        },
        calculBadNeighbors(index) {
            let count = 0;
            let relativeX = index % this.size;
            let curIndex;
            for (let y = -1; y <= 1; y++) {
                for (let x = -1; x <= 1; x++) {
                    if (
                        (x === -1 && relativeX > 0) ||
                        x === 0 ||
                        (x === 1 && relativeX < this.size - 1)
                    ) {
                        curIndex = parseInt(index) + y * this.size + x;
                        if (curIndex >= 0 && curIndex < this.size * this.size) {
                            if (this.cells[curIndex].bomb) {
                                count++;
                            }
                        }
                    }
                }
            }
            this.cells[index].badNeighbors = count;
        },
        releaseGoodNeighborsCells(index) {
            let count = 0;
            let relativeX = index % this.size;
            //console.log(index, relativeX);
            let curIndex;
            for (let y = -1; y <= 1; y++) {
                for (let x = -1; x <= 1; x++) {
                    if (
                        (x === -1 && relativeX > 0) ||
                        x === 0 ||
                        (x === 1 && relativeX < this.size - 1)
                    ) {
                        curIndex = parseInt(index) + y * this.size + x;
                        //console.log('check index : ' + curIndex);
                        //console.log('position: (' + x + ',' + y + ')');
                        if (
                            curIndex >= 0 &&
                            curIndex <= this.size * this.size &&
                            this.cells[curIndex] &&
                            this.cells[curIndex].status === 'untouched' &&
                            !this.cells[curIndex].bomb
                        ) {
                            //console.log('revealed !');
                            this.cells[curIndex].status = 'dug';
                            this.cellsLeft += -1;
                            if (this.cells[curIndex].badNeighbors === 0) {
                                //console.log('go next index : ' + curIndex);
                                this.releaseGoodNeighborsCells(curIndex);
                            }
                        }
                    }
                }
            }
        },
        testGameRules(event) {
            if (event.status === 'detonated') {
                this.$emit('interface', { type: 'game', data: 'lost' });
            }
            if (this.cellsLeft <= 0) {
                this.$emit('interface', { type: 'game', data: 'win' });
            }
        },
        handleChangedState(event) {
            // deep copy of cells (for undo)
            this.cellsCopy = JSON.parse(JSON.stringify(this.cells));
            this.cellsLeftCopy = JSON.parse(JSON.stringify(this.cellsLeft));
            this.undoIsNotPossible = false;

            // Apply state change
            this.cells[event.index].status = event.status;
            if (event.status === 'dug') {
                this.cellsLeft += -1;
                if (this.cells[event.index].badNeighbors === 0) {
                    this.cellsCleaned = [];
                    this.releaseGoodNeighborsCells(event.index);
                }
            } else if (event.status === 'flagged') {
                this.$emit('interface', {
                    type: 'score',
                    data: 'flag',
                    score: -1,
                });
            }
            this.testGameRules(event);
        },

        undo() {
            if (!this.undoIsNotPossible) {
                // Deep copy of ancient state
                this.cells = JSON.parse(JSON.stringify(this.cellsCopy));
                this.cellsLeft = JSON.parse(JSON.stringify(this.cellsLeftCopy));
                this.undoIsNotPossible = true;
                // On retire 5 points (à Serpentard ! ...pardon, j'ai pas resisté)
                this.$emit('interface', {
                    type: 'score',
                    data: 'undo',
                    score: -5,
                });
            }
        },
    },
};
</script>

<style scoped>
#grid-container {
    display: block;
    height: 96vmin;
    width: 96vmin;
    padding: 16vmin;
    margin: 0 auto;
    background: url('../assets/island.png') no-repeat;
    background-size: contain;
    text-align: center;
}

#grid {
    display: flex;
    border: none;
    flex-wrap: wrap;
    height: 64vmin;
    width: 64vmin;
    padding: 0;
}

#undo {
    position: relative;
    top: 1vmin;
    width: 20vmin;
    height: 6vmin;
    line-height: 6vmin;
    cursor: pointer;
    border: none;
    background: url('../assets/button.png') no-repeat;
    background-size: contain;
}
</style>

<template>
    <div id="grid-container">
        <div id="grid">
            <Cell
                v-for="(cell, n) in cells"
                v-bind:key="n"
                v-bind:index="n"
                v-bind="cell"
                v-bind:gameState="gameState"
                @interface="handleChangedState"
            />
        </div>
        <button
            id="undo"
            @click="undo()"
            :disabled="undoIsNotPossible"
            class="undoButton"
        >Annuler action (-5pts)</button>
    </div>
</template>