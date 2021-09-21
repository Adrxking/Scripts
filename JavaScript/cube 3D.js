let y = 0, bool = false, interval;

var leftArrow = document.querySelector('.left-arrow');
var rightArrow = document.querySelector('.right-arrow');

var playPause = document.querySelector('.play-pause');

const rotate = () => {
    const cubes = document.querySelectorAll('.cube');
        
    Array.from(cubes).forEach(cube => cube.style.transform = `rotateY(${y}deg)`);
}

const changePlayPause = () => {
    const i = document.querySelector('.play-pause i');
    const className = i.classList[1];
    if(className === 'fa-play') {
        i.classList.remove('fa-play');
        i.classList.add('fa-pause');
    } else{
        i.classList.add('fa-play');
        i.classList.remove('fa-pause');
    }

};

const playPauseEvent = () => {
    if(!bool) {
        interval = setInterval(() => {
            y -= 90;
            rotate();
        }, 2500);
        changePlayPause();
        bool = true;
    } else {
        clearInterval(interval);
        changePlayPause();
        bool = false;
    }
};

if(leftArrow) {
    leftArrow.addEventListener('click', () => {
        y+=90;
        rotate();
        if(bool) {
            playPauseEvent();
        }
    });
};
if(rightArrow) {
    rightArrow.addEventListener('click', () => {
        y-=90;
        rotate();
        if(bool) {
            playPauseEvent();
        }
    });
};
if(leftArrow) {
    leftArrow.addEventListener('mouseover', () => {
        y+=25;
        rotate();
    });
};
if(rightArrow) {
    rightArrow.addEventListener('mouseover', () => {
        y-=25;
        rotate();
    });
};
if(leftArrow) {
    leftArrow.addEventListener('mouseout', () => {
        y-=25;
        rotate();
    });
};
if(rightArrow) {
    rightArrow.addEventListener('mouseout', () => {
        y+=25;
        rotate();
    });
};
if(playPause){
    playPause.addEventListener('click', () => {
        playPauseEvent();
    })
};