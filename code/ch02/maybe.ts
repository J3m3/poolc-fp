class Maybe<T> {
  private _value: T | undefined;

  constructor(value?: T) {
    this._value = value;
  }

  get value() {
    if (this.isNothing()) {
      throw new TypeError("Can't extract the value from Nothing");
    }
    return this._value;
  }

  isNothing() {
    return this.value === undefined;
  }

  map<U>(fn: (x: T) => U): Maybe<U> {
    if (this.isNothing()) {
      return new Maybe<U>();
    }
    return new Maybe<U>(fn(this._value as T));
  }
}
