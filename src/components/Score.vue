<script>
export default {
    name: 'Score',
    props: ['score', 'gameState'],
    watch: {
        score: 'refreshContent',
        timeSec: 'refreshTime',
        timeMin: 'refreshTime',
    },
    data() {
        return {
            content: '',
            timer: '',
            timeSec: 0,
            timeMin: 0,
            timeInterval: null,
            secondsBeforeLoosePoint: 5,
            secondsCountPoint: 0,
        };
    },
    methods: {
        reset() {
            this.timeSec = 0;
            this.timeMin = 0;
            if (this.timeInterval) {
                clearInterval(this.timeInterval);
                this.timeInterval = null;
            }
            this.timeInterval = setInterval(this.loopTime, 1000);
        },
        refreshContent() {
            this.content = this.score + '';
        },
        refreshTime() {
            let timer = '';
            if (this.timeMin < 10) {
                timer = '0' + this.timeMin + ':';
            } else {
                timer = this.timeMin + ':';
            }

            if (this.timeSec < 10) {
                timer += '0' + this.timeSec;
            } else {
                timer += this.timeSec + '';
            }

            this.timer = timer;
        },
        loopTime() {
            if (this.gameState === '') {
                this.timeSec++;
                if (this.timeSec > 60) {
                    this.timeSec = 0;
                    this.timeMin++;
                }
                this.secondsCountPoint++;
                if (this.secondsCountPoint > this.secondsBeforeLoosePoint) {
                    this.secondsCountPoint = 0;
                    this.$emit('interface', {
                        type: 'score',
                        data: 'time',
                        score: -1,
                    });
                }
            }
        },
    },
    created() {},
    mounted() {},
};
</script>

<style scoped>
#score {
    position: absolute;
    bottom: 85vmin;
    left: 50%;
    width: 50%;
    height: 10vmin;
}

.pan {
    display: inline-block;
    width: 13vmin;
    height: 10vmin;
    line-height: 2vmin;
    padding: 1vmin 1vmin 5vmin 1vmin;
    text-align: center;
    font-size: 0.9em;
    background: url('../assets/panneau.png') no-repeat;
    background-size: contain;
    color: #695f4c;
}
</style>

<template>
    <div id="score">
        <div class="pan">
            <div>Score</div>
            <div>{{content}}</div>
        </div>
        <div class="pan">
            <div>Temps</div>
            <div>{{timer}}</div>
        </div>
    </div>
</template>