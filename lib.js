// inertia standard library

function nth(list, n) {
    if (list.length && list.length + 1 < n) {
        return null;
    }

    return list[n];
}

function first(list) {
    return nth(list, 0);
}

function rest(list) {
    return list.slice(1);
}

function second(list) {
    return nth(list, 1);
}

function last(list) {
    return nth(list, list.length - 1);
}

function count(list) {
    return list.length;
}

function take(n, list) {
  return list.slice(0, n);
}

function partition(n, list) {
    if (list.length % n !== 0) {
        throw Error('Uneven number of elements.');
    }

    if (list.length === 0) {
        return [];
    }

    return conj(
        [take(n, list)],
        partition(n, list.slice(n))
    );
}

function cons(a, list) {
    return [a].concat(list);
}

function conj(list, a) {
    return list.concat(a);
}

function get(obj, key) {
    if (obj.hasOwnProperty(key)) {
        return obj[key];
    }

    return null;
}

function map(fn, list) {
    return list.map(fn);
}

function filter(fn, list) {
    return list.filter(fn);
}


// inertia standard library end



