
//Random color
function getColor() {
    var randomColor = Math.floor(Math.random() * 16777215).toString(16);
    return randomColor
}

function genColors(){
    var colors = []
    for(var i = 10; i < 99; i ++){
      var color = getColor()
      colors[i] = color
    }
    return colors
}

//This function code needs to modified so that it works with Your cat code.
function headColor(color,code) {
    $('#head, #body, .ear').css('background', '#' + color)  //This changes the color of the cat
    $('#headcode').html('code: '+code) //This updates text of the badge next to the slider
    $('#dnabody').html(code) //This updates the body color part of the DNA that is displayed below the cat
}
function mouthColor(color,code) {
    $('.mouth').css('background', '#' + color)  //This changes the color of the cat
    $('#mouthcode').html('code: '+code) //This updates text of the badge next to the slider
    $('#dnamouth').html(code) //This updates the body color part of the DNA that is displayed below the cat
}
function eyesColor(color,code) {
    $('.eye').css('background', '#' + color)  //This changes the color of the cat
    $('#eyecode').html('code: '+code) //This updates text of the badge next to the slider
    $('#dnaeyes').html(code) //This updates the body color part of the DNA that is displayed below the cat
}
function earsColor(color,code) {
    $('.left_ear_inner, .right_ear_inner').css('background', '#' + color)  //This changes the color of the cat
    $('#earcode').html('code: '+code) //This updates text of the badge next to the slider
    $('#dnaears').html(code) //This updates the body color part of the DNA that is displayed below the cat
}
function patternColor(color,code) {
    $('.decorativepattern1').css('background', '#' + color)  //This changes the color of the cat
    $('#patterncode').html('code: '+code) //This updates text of the badge next to the slider
    $('#dnadecorationMid').html(code) //This updates the body color part of the DNA that is displayed below the cat
}
//###################################################
//Functions below will be used later on in the project
//###################################################
function eyeVariation(num) {

    $('#dnashape').html(num)
    switch (num) {
        case 1:
            normalEyes()
            $('#eyeName').html('Basic')
            break
        case 2:
            normalEyes()
            $('#eyeName').html('Chill')
            eyesType1()
            break
        default:
            console.log("Not 1 or 2")
            break
        
    }
}

function decorationVariation(num) {
    $('#dnadecoration').html(num)
    switch (num) {
        case 1:
            $('#decorationName').html('Diamond')
            normaldecoration()
            break
        case 2:
            normaldecoration()
            $('#decorationName').html('Triangle')
            alternativedecoration()
            break
    }
}

function normalEyes() {
     $('.eye').find('span').css('border', 'none')
}
function eyesType1() {
     $('.eye').find('span').css('border-top', '15px solid')
}
function normaldecoration() {
    //Remove all style from other decorations
    //In this way we can also use normalDecoration() to reset the decoration style
    $('.decorativepattern1').css({ "transform": "rotate(45deg)", "height": "40px", "width": "40px", "top": "20px" })
    $('.cat__head-dots_second').css({ "transform": "rotate(0deg)", "height": "100px", "width": "14px", "top": "1px", "border-radius": "0 50% 50% 50%" })
}
function alternativedecoration(){
    $('.decorativepattern1').css({ "transform": "rotate(65deg)", "height": "50px", "width": "40px", "top": "20px" })
    console.log("tried to call the function transforming the shape in to triangle")
}