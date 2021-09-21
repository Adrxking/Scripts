var slide = document.querySelector("#slide");
var upArrow = document.querySelector('#upArrow');
var downArrow = document.querySelector("#downArrow");
if(slide){
    let x = 0;
    if(upArrow){
        upArrow.addEventListener('click', () =>{
            if(x < 0){
                x = x + 29;
                slide.style.top = x + "rem";
            } else {
                x = x - 116;
                slide.style.top = x + "rem";
            }
        });
    }

    var goDown = function() {
        if(x > "-116") {
            x = x - 29;
            slide.style.top = x + "rem";
        } else {
            x = x + 116;
            slide.style.top = x + "rem";
        }
    };

    if(downArrow){
        downArrow.addEventListener('click', () => {
        goDown();
        });
    }

    setInterval(function() {
        goDown();  
    }, 3500);
}