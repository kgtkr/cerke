let shuffle = (array, generator) => {
    for(i in Array.length(array) - 1 downto 1) {
        let r = Js.Math.floor((generator -> RandomSeed.random()) *. (Js.Int.toFloat(i) +. 1.));
        let tmp = array[i];
        array[i] = array[r];
        array[r] = tmp;
    }
};