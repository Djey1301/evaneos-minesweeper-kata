import Vue from 'vue';
import Router from 'vue-router';
import HomeRoutes from '@/router/Home';
import IntroRoutes from '@/router/Intro';
import GameboardRoutes from '@/router/Gameboard';

Vue.use(Router);

const routes = [].concat(HomeRoutes, IntroRoutes, GameboardRoutes);

export default new Router({
    mode: 'history',
    base: __dirname,
    routes: routes,
});
