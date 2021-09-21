document.querySelector('.site-header .menu-btn').addEventListener('click', () => {
    document.querySelector('.site-header .menu-container').classList.toggle('open');
    document.querySelector('.site-header .menu-btn').classList.toggle('open');
    document.querySelector('.site-header').classList.toggle('background-black');
});