<script>
export default {
    name: 'Cell',
    props: ['index', 'size', 'badNeighbors', 'bomb', 'status', 'gameState'],
    computed: {
        style() {
            return (
                'width: calc(64vmin / ' +
                this.size +
                ');height: calc(64vmin / ' +
                this.size +
                ');line-height: calc(64vmin / ' +
                this.size +
                ');'
            );
        },
    },
    watch: {
        status: 'refreshContent',
        badNeighbors: 'refreshContent',
    },
    data() {
        return {
            emojis: {
                untouched: '',
                dug: '',
                flagged: '🚩',
                detonated: '💥',
            },
            content: '',
            classes: 'cell',
            colors: [
                '',
                'darkGreen',
                'blue',
                'purple',
                'red',
                'red',
                'red',
                'red',
            ],
        };
    },
    methods: {
        refreshContent() {
            if (this.status === 'dug') {
                if (this.badNeighbors > 0) {
                    this.content =
                        '<span style="color:' +
                        this.colors[this.badNeighbors] +
                        '">' +
                        this.badNeighbors +
                        '</span>';
                } else {
                    this.content = '';
                }
                this.classes += ' dug';
            } else {
                this.content = this.emojis[this.status];
                this.classes = 'cell';
            }
        },
        openCell(e) {
            e.preventDefault();
            if (this.gameState === '') {
                let status;
                if (this.bomb) {
                    status = 'detonated';
                } else {
                    status = 'dug';
                }
                this.$emit('interface', { index: this.index, status: status });
            }
        },
        flagCell(e) {
            e.preventDefault();
            if (this.gameState === '') {
                let status;
                if (this.status !== 'detonated' && this.status !== 'dug') {
                    status = 'flagged';
                }
                this.$emit('interface', { index: this.index, status: status });
            }
        },
    },
    mounted() {},
};
</script>

<style scoped>
.cell {
    background: none;
    border: 1px solid #89ff5d;
    cursor: pointer;
    text-align: center;
    border-radius: 50%;
    font-weight: bold;
    font-size: 1em;
    text-shadow: 1px 1px 2px white, 0 0 1em white, 0 0 0.2em white;
}

.dug {
    background: url('../assets/hole.png') no-repeat;
    background-size: contain;
    border: none !important;
}
</style>

<template>
    <div
        v-bind:class="classes"
        v-bind:style="style"
        @click="openCell"
        @contextmenu="flagCell"
        v-html="content"
    ></div>
</template>