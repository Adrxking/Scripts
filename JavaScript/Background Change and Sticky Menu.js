window.onscroll = () => {
    const scroll = window.scrollY;

    const headerNav = document.querySelector('.site-header');
    const documentBody = document.querySelector('body');
    const headLandPage = document.querySelector('.head');
    const contentLandPage = document.querySelector('.web-content');
    const IntroductionWebPage = document.querySelector('.web-introduction');
    const contextWebPage = document.querySelector('.web-context');
    const workWebPage = document.querySelector('.web-work');
    const cubeBackground = document.querySelector('.web-container');

    if(contextWebPage, cubeBackground, IntroductionWebPage){
        if(scroll > 400) {
            workWebPage.classList.add('scrolled');
            contextWebPage.classList.add('scrolled');
            IntroductionWebPage.classList.add('scrolled');
            cubeBackground.classList.add('scrolled');
        } else {
            workWebPage.classList.remove('scrolled');
            contextWebPage.classList.remove('scrolled');
            IntroductionWebPage.classList.remove('scrolled');
            cubeBackground.classList.remove('scrolled');
        }
    }

    if(headLandPage, contentLandPage){
        if(scroll > 900) {
            headLandPage.classList.add('scrolled');
            contentLandPage.classList.add('scrolled');
        } else {
            headLandPage.classList.remove('scrolled');
            contentLandPage.classList.remove('scrolled');
        }
    }

    if(scroll > 300) {
        headerNav.classList.add('fixed-top');
        documentBody.classList.add('ft-activo');
    } else {
        headerNav.classList.remove('fixed-top');
        documentBody.classList.remove('ft-activo');
    }
};