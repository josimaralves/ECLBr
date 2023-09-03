{
             ECL Brasil - Essential Core Library for Delphi

                   Copyright (c) 2016, Isaque Pinheiro
                          All rights reserved.

                    GNU Lesser General Public License
                      Vers�o 3, 29 de junho de 2007

       Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
       A todos � permitido copiar e distribuir c�pias deste documento de
       licen�a, mas mud�-lo n�o � permitido.

       Esta vers�o da GNU Lesser General Public License incorpora
       os termos e condi��es da vers�o 3 da GNU General Public License
       Licen�a, complementado pelas permiss�es adicionais listadas no
       arquivo LICENSE na pasta principal.
}

{
  @abstract(ECLBr Library)
  @created(23 Abr 2023)
  @author(Isaque Pinheiro <isaquepsp@gmail.com>)
  @Telegram(https://t.me/ormbr)
}

unit eclbr.sysdictionary;

interface

uses
  Rtti,
  SysUtils,
  eclbr.syslist,
  Generics.Defaults,
  Generics.Collections;

type
  TDictionaryHelper<K,V> = class(TDictionary<K,V>)
  private
    function _ComparePairs(const Left, Right: TPair<K, V>): Integer;
  public
    /// <summary>
    ///   Adds the key-value pairs from another dictionary to this dictionary.
    /// </summary>
    /// <param name="ASource">The source dictionary containing key-value pairs to add.</param>
    procedure AddRange(const ASource: TDictionary<K,V>);

    /// <summary>
    ///   Iterates through each key-value pair in the dictionary and performs an action on them.
    /// </summary>
    /// <param name="AAction">The action to be performed on each key-value pair.</param>
    procedure ForEach(const AAction: TProc<K, V>);

    /// <summary>
    ///   Iterates through each key-value pair in the dictionary along with its index and performs an action on them.
    /// </summary>
    /// <param name="AAction">The action to be performed on each indexed key-value pair.</param>
    procedure ForEachIndexed(const AAction: TProc<Integer, K, V>);

    /// <summary>
    ///   Rotates the dictionary by a specified number of positions.
    /// </summary>
    /// <param name="ACount">The number of positions to rotate the dictionary.</param>
    function Rotate(const ACount: Integer): TArray<TPair<K, V>>;

    /// <summary>
    ///   Removes duplicate values from the dictionary, keeping only the first occurrence of each value.
    /// </summary>
    procedure Unique;

    procedure FreeValues;

    /// <summary>
    ///   Returns the sorted keys of the dictionary.
    /// </summary>
    function SortedKeys: TArray<K>;

    /// <summary>
    ///   Shuffles the keys of the dictionary.
    /// </summary>
    function ShuffleKeys: TArray<K>;

    /// <summary>
    ///   Maps the values of the dictionary to a new dictionary of results.
    /// </summary>
    /// <typeparam name="TResult">The type of the mapped results.</typeparam>
    /// <param name="AMappingFunc">The mapping function to be applied to each value.</param>
    function Map<TResult>(const AMappingFunc: TFunc<V, TResult>): TDictionaryHelper<K, TResult>;

    /// <summary>
    ///   Filters the values of the dictionary based on a specified predicate.
    /// </summary>
    /// <param name="APredicate">The predicate used to filter the values.</param>
    function Filter(const APredicate: TFunc<V, Boolean>): TDictionaryHelper<K, V>;

    /// <summary>
    ///   Reduces the values of the dictionary to a single value using an accumulator function.
    /// </summary>
    /// <typeparam name="TResult">The type of the reduction result.</typeparam>
    /// <param name="AAccumulator">The accumulator function used to reduce the values.</param>
    function Reduce(const AAccumulator: TFunc<V, V, V>): V;

    /// <summary>
    ///   Groups the values of the dictionary by a key selector and returns a new dictionary with grouped value lists.
    /// </summary>
    /// <typeparam name="TKey">The type of the grouping key.</typeparam>
    /// <param name="AKeySelector">The key selector function.</param>
    function GroupBy<TKey>(const AKeySelector: TFunc<V, TKey>): TDictionary<TKey, TList<V>>;

    /// <summary>
    ///   Joins the values of the dictionary into a single string, separated by the specified separator.
    /// </summary>
    /// <param name="ASeparator">The separator used to join the values.</param>
    function Join(const ASeparator: string): string;

    /// <summary>
    ///   Partitions the dictionary into two dictionaries based on a given predicate.
    /// </summary>
    /// <param name="APredicate">The predicate used to partition the dictionary.</param>
    /// <returns>
    ///   A pair of dictionaries where the first dictionary contains key-value pairs that satisfy the predicate,
    ///   and the second dictionary contains key-value pairs that do not satisfy the predicate.
    /// </returns>
    function Partition(const APredicate: TFunc<V, Boolean>): TPair<TDictionaryHelper<K, V>, TDictionaryHelper<K, V>>;

    /// <summary>
    ///   Takes a specified number of key-value pairs from the beginning of the dictionary.
    /// </summary>
    /// <param name="ACount">The number of key-value pairs to take.</param>
    /// <returns>A new dictionary with the specified number of key-value pairs from the start.</returns>
    function Take(const ACount: Integer): TDictionaryHelper<K, V>;

    /// <summary>
    ///   Skips a specified number of key-value pairs from the beginning of the dictionary and returns the remaining pairs.
    /// </summary>
    /// <param name="ACount">The number of key-value pairs to skip.</param>
    /// <returns>A new dictionary with key-value pairs after skipping the specified number of pairs.</returns>
    function Skip(const ACount: Integer): TDictionaryHelper<K, V>;

    /// <summary>
    ///   Creates a new dictionary containing key-value pairs from the specified start index to the end index.
    /// </summary>
    /// <param name="AStartIndex">The starting index for slicing.</param>
    /// <param name="AEndIndex">The ending index for slicing.</param>
    /// <returns>A new dictionary with the sliced key-value pairs.</returns>
    function Slice(AStartIndex, AEndIndex: Integer): TDictionaryHelper<K, V>;

    /// <summary>
    ///   Combines two dictionaries with a specified function to create a new dictionary.
    /// </summary>
    /// <typeparam name="T1">The value type of the first dictionary.</typeparam>
    /// <typeparam name="T2">The value type of the second dictionary.</typeparam>
    /// <typeparam name="TResult">The value type of the result dictionary.</typeparam>
    /// <param name="AList1">The first dictionary to combine.</param>
    /// <param name="AList2">The second dictionary to combine.</param>
    /// <param name="AFunc">The function to apply to each pair of values.</param>
    /// <returns>A new dictionary with values resulting from applying the function to corresponding pairs.</returns>
    function Zip<T1, T2, TResult>(const AList1: TDictionaryHelper<K, T1>; const AList2: TDictionaryHelper<K, T2>;
      const AFunc: TFunc<T1, T2, TResult>): TDictionaryHelper<K, TResult>;

    /// <summary>
    ///   Maps each value in the dictionary to an array of results and flattens the results into a single dictionary.
    /// </summary>
    /// <typeparam name="TResult">The value type of the result dictionary.</typeparam>
    /// <param name="AFunc">The function to map each value to an array of results.</param>
    /// <returns>A new dictionary containing flattened results.</returns>
    function FlatMap<TResult>(const AFunc: TFunc<TValue, TArray<TResult>>): TDictionaryHelper<K, TResult>;

    /// <summary>
    ///   Returns a new dictionary containing key-value pairs that are common between two dictionaries.
    /// </summary>
    /// <param name="AOtherDict">The other dictionary to intersect with.</param>
    /// <returns>A new dictionary containing common key-value pairs.</returns>
    function Intersect(const AOtherDict: TDictionaryHelper<K, V>): TDictionaryHelper<K, V>;

    /// <summary>
    ///   Returns a new dictionary containing key-value pairs that exist in the current dictionary but not in another dictionary.
    /// </summary>
    /// <param name="AOtherDict">The other dictionary to compare.</param>
    /// <returns>A new dictionary containing key-value pairs not present in the other dictionary.</returns>
    function &Except(const AOtherDict: TDictionaryHelper<K, V>): TDictionaryHelper<K, V>;

    /// <summary>
    ///   Returns the maximum key in the dictionary.
    /// </summary>
    /// <returns>The maximum key in the dictionary.</returns>
    function Max: K;

    /// <summary>
    ///   Returns the minimum key in the dictionary.
    /// </summary>
    /// <returns>The minimum key in the dictionary.</returns>
    function Min: K;

    /// <summary>
    ///   Returns a new dictionary with distinct keys based on the selected key selector function.
    /// </summary>
    /// <typeparam name="TKey">The type of the key used for distinct selection.</typeparam>
    /// <param name="AKeySelector">The function used to select keys for distinct values.</param>
    /// <returns>A new dictionary with distinct keys.</returns>
    function DistinctBy<TKey>(const AKeySelector: TFunc<K, TKey>): TDictionary<TKey, V>;

    /// <summary>
    ///   Returns a new dictionary containing key-value pairs that satisfy the given predicate.
    /// </summary>
    /// <param name="APredicate">The predicate used to filter key-value pairs.</param>
    /// <returns>A new dictionary containing filtered key-value pairs.</returns>
    function FindAll(const APredicate: TFunc<V, Boolean>): TDictionary<K, V>;

    /// <summary>
    ///   Returns a new dictionary containing key-value pairs from the beginning of the dictionary
    ///   while the specified predicate is true.
    /// </summary>
    /// <param name="APredicate">The predicate used to take key-value pairs.</param>
    /// <returns>A new dictionary containing key-value pairs that match the predicate.</returns>
    function TakeWhile(const APredicate: TFunc<K, Boolean>): TDictionary<K, V>;

    /// <summary>
    ///   Skips key-value pairs from the beginning of the dictionary while the specified predicate is true
    ///   and returns the remaining key-value pairs.
    /// </summary>
    /// <param name="APredicate">The predicate used to skip key-value pairs.</param>
    /// <returns>A new dictionary containing key-value pairs after skipping while the predicate is true.</returns>
    function SkipWhile(const APredicate: TFunc<K, Boolean>): TDictionary<K, V>;

    /// <summary>
    ///   Partitions the dictionary into two groups based on the given predicate.
    ///   Keys that satisfy the predicate are placed in one group, and keys that do not satisfy it are placed in another group.
    /// </summary>
    /// <param name="APredicate">The predicate used for partitioning.</param>
    /// <returns>
    ///   A new dictionary with two entries: one entry for keys that satisfy the predicate (true) and another for keys that do not (false).
    /// </returns>
    function PartitionBy(const APredicate: TFunc<V, Boolean>): TDictionary<Boolean, TList<V>>;

    /// <summary>
    ///   Returns the last key in the dictionary.
    /// </summary>
    /// <returns>The last key in the dictionary.</returns>
    function LastKey: K;

    /// <summary>
    ///   Returns the last value in the dictionary.
    /// </summary>
    /// <returns>The last value in the dictionary.</returns>
    function LastValue: V;

    /// <summary>
    ///   Returns a string representation of the dictionary.
    /// </summary>
    /// <returns>A string representation of the key-value pairs in the dictionary.</returns>
    function ToString: string; override;
  end;

implementation

{ TDictionaryHelper<K, V> }

function TDictionaryHelper<K, V>.DistinctBy<TKey>(
  const AKeySelector: TFunc<K, TKey>): TDictionary<TKey, V>;
var
  LPair: TPair<K, V>;
  LKey: TValue;
begin
  Result := TDictionary<TKey, V>.Create;
  for LPair in Self do
  begin
    if not Result.ContainsKey(AKeySelector(LPair.Key)) then
    begin
      LKey := TValue.From<K>(LPair.Key);
      Result.Add(LKey.AsType<TKey>, LPair.Value);
    end;
  end;
end;

function TDictionaryHelper<K, V>.&Except(
  const AOtherDict: TDictionaryHelper<K, V>): TDictionaryHelper<K, V>;
var
  LPair: TPair<K, V>;
begin
  Result := TDictionaryHelper<K, V>.Create;

  for LPair in Self do
  begin
    if not AOtherDict.ContainsKey(LPair.Key) then
      Result.Add(LPair.Key, LPair.Value);
  end;
end;

procedure TDictionaryHelper<K, V>.AddRange(const ASource: TDictionary<K, V>);
var
  LPair: TPair<K, V>;
begin
  for LPair in ASource do
    Self.Add(LPair.Key, LPair.Value);
end;

function TDictionaryHelper<K, V>.Filter(
  const APredicate: TFunc<V, Boolean>): TDictionaryHelper<K, V>;
var
  LPair: TPair<K, V>;
begin
  Result := TDictionaryHelper<K, V>.Create;
  try
    for LPair in Self do
    begin
      if APredicate(LPair.Value) then
        Result.Add(LPair.Key, LPair.Value);
    end;
  except
    Result.Free;
    raise;
  end;
end;

function TDictionaryHelper<K, V>.FindAll(
  const APredicate: TFunc<V, Boolean>): TDictionary<K, V>;
var
  LPair: TPair<K, V>;
begin
  Result := TDictionary<K, V>.Create;

  for LPair in Self do
  begin
    if APredicate(LPair.Value) then
      Result.Add(LPair.Key, LPair.Value);
  end;
end;

function TDictionaryHelper<K, V>.FlatMap<TResult>(
  const AFunc: TFunc<TValue, TArray<TResult>>): TDictionaryHelper<K, TResult>;
var
  LPair: TPair<K, V>;
  LValue: TValue;
  LResultArray: TArray<TResult>;
  LResult: TResult;
begin
  Result := TDictionaryHelper<K, TResult>.Create;

  for LPair in Self do
  begin
    LValue := TValue.From<V>(LPair.Value);
    LResultArray := AFunc(LValue);

    for LResult in LResultArray do
      Result.Add(LPair.Key, LResult);
  end;
end;

procedure TDictionaryHelper<K, V>.ForEach(const AAction: TProc<K, V>);
var
  LPair: TPair<K, V>;
begin
  for LPair in Self do
    AAction(LPair.Key, LPair.Value);
end;

procedure TDictionaryHelper<K, V>.ForEachIndexed(
  const AAction: TProc<Integer, K, V>);
var
  LIndex: Integer;
  LSortedKeys: TArray<K>;
  LKey: K;
begin
  LSortedKeys := SortedKeys;
  for LIndex := 0 to Length(LSortedKeys) - 1 do
  begin
    LKey := LSortedKeys[LIndex];
    AAction(LIndex, LKey, Self[LKey]);
  end;
end;

procedure TDictionaryHelper<K, V>.FreeValues;
var
  LItem: V;
  LValue: TValue;
begin
  for LItem in Values do
  begin
    LValue := TValue.From<V>(LItem);
    if LValue.IsObject then
      TObject(LValue.AsObject).Free;
  end;
end;

function TDictionaryHelper<K, V>.GroupBy<TKey>(
  const AKeySelector: TFunc<V, TKey>): TDictionary<TKey, TList<V>>;
var
  LPair: TPair<K, V>;
  LKey: TKey;
  LGroupedDict: TDictionary<TKey, TList<V>>;
  LList: TList<V>;
begin
  LGroupedDict := TDictionary<TKey, TList<V>>.Create;

  for LPair in Self do
  begin
    LKey := AKeySelector(LPair.Value);
    if not LGroupedDict.TryGetValue(LKey, LList) then
    begin
      LList := TList<V>.Create;
      LGroupedDict.Add(LKey, LList);
    end;
    LList.Add(LPair.Value);
  end;
  Result := LGroupedDict;
end;

function TDictionaryHelper<K, V>.Intersect(
  const AOtherDict: TDictionaryHelper<K, V>): TDictionaryHelper<K, V>;
var
  LPair: TPair<K, V>;
begin
  Result := TDictionaryHelper<K, V>.Create;

  for LPair in Self do
  begin
    if AOtherDict.ContainsKey(LPair.Key) then
      Result.Add(LPair.Key, LPair.Value);
  end;
end;

function TDictionaryHelper<K, V>.Join(const ASeparator: string): string;
var
  LPair: TPair<K, V>;
  LList: TListHelper<string>;
  LValue: TValue;
begin
  LList := TListHelper<string>.Create;
  for LPair in Self do
  begin
    LValue := TValue.From<V>(LPair.Value);
    LList.Add(LValue.ToString);
  end;
  Result := LList.Join(ASeparator);
  LList.Free;
end;

function TDictionaryHelper<K,V>.LastKey: K;
var
  LKey: K;
begin
  Result := Default(K);
  for LKey in Self.Keys do
    Result := LKey;
end;

function TDictionaryHelper<K, V>.LastValue: V;
var
  LValue: V;
begin
  Result := Default(V);
  for LValue in Self.Values do
    Result := LValue;
end;

function TDictionaryHelper<K, V>.Map<TResult>(
  const AMappingFunc: TFunc<V, TResult>): TDictionaryHelper<K, TResult>;
var
  LPair: TPair<K, V>;
begin
  Result := TDictionaryHelper<K, TResult>.Create;
  try
    for LPair in Self do
      Result.Add(LPair.Key, AMappingFunc(LPair.Value));
  except
    Result.Free;
    raise;
  end;
end;

function TDictionaryHelper<K, V>.Max: K;
var
  LPair: TPair<K, V>;
  LMaxKey: K;
  LIsFirst: Boolean;
begin
  LIsFirst := True;
  for LPair in Self do
  begin
    if LIsFirst or (TComparer<K>.Default.Compare(LPair.Key, LMaxKey) > 0) then
    begin
      LMaxKey := LPair.Key;
      LIsFirst := False;
    end;
  end;
  if LIsFirst then
    raise Exception.Create('The dictionary is empty.');

  Result := LMaxKey;
end;

function TDictionaryHelper<K, V>.Min: K;
var
  LPair: TPair<K, V>;
  LMinKey: K;
  LIsFirst: Boolean;
begin
  if Count = 0 then
    raise Exception.Create('The dictionary is empty.');

  LIsFirst := True;
  for LPair in Self do
  begin
    if LIsFirst or (TComparer<K>.Default.Compare(LPair.Key, LMinKey) < 0) then
    begin
      LMinKey := LPair.Key;
      LIsFirst := False;
    end;
  end;
  if LIsFirst then
    raise Exception.Create('No minimum key found in the dictionary.');

  Result := LMinKey;
end;

function TDictionaryHelper<K, V>.Partition(
  const APredicate: TFunc<V, Boolean>): TPair<TDictionaryHelper<K, V>,
                                              TDictionaryHelper<K, V>>;
var
  LPair: TPair<K, V>;
  LTrueDict, LFalseDict: TDictionaryHelper<K, V>;
begin
  LTrueDict := TDictionaryHelper<K, V>.Create;
  LFalseDict := TDictionaryHelper<K, V>.Create;
  for LPair in Self do
  begin
    if APredicate(LPair.Value) then
      LTrueDict.Add(LPair.Key, LPair.Value)
    else
      LFalseDict.Add(LPair.Key, LPair.Value);
  end;
  Result := TPair<TDictionaryHelper<K, V>,
                  TDictionaryHelper<K, V>>.Create(LTrueDict, LFalseDict);
end;

function TDictionaryHelper<K, V>.PartitionBy(
  const APredicate: TFunc<V, Boolean>): TDictionary<Boolean, TList<V>>;
var
  LPair: TPair<K, V>;
  LValue: V;
  LKey: Boolean;
begin
  Result := TDictionary<Boolean, TList<V>>.Create;

  for LPair in Self do
  begin
    LValue := LPair.Value;
    LKey := APredicate(LValue);

    if not Result.ContainsKey(LKey) then
      Result[LKey] := TList<V>.Create;

    Result[LKey].Add(LValue);
  end;
end;

function TDictionaryHelper<K, V>.Reduce(const AAccumulator: TFunc<V, V, V>): V;
var
  LPair: TPair<K, V>;
  LAccumulatedValue: V;
begin
  LAccumulatedValue := Default(V);
  for LPair in Self do
  begin
    LAccumulatedValue := AAccumulator(LAccumulatedValue, LPair.Value);
  end;
  Result := LAccumulatedValue;
end;

function TDictionaryHelper<K, V>.Rotate(const ACount: Integer): TArray<TPair<K, V>>;
var
  LSortedKeysArray: TArray<K>;
  LList: TList<TPair<K, V>>;
  LIndex, LNewIndex: Integer;
begin
  LSortedKeysArray := SortedKeys;
  SetLength(Result, Length(LSortedKeysArray));

  for LIndex := 0 to High(LSortedKeysArray) do
  begin
    LNewIndex := (LIndex + (ACount + Length(LSortedKeysArray))) mod Length(LSortedKeysArray);
    Result[LNewIndex] := TPair<K, V>.Create(LSortedKeysArray[LIndex], Self[LSortedKeysArray[LIndex]]);
  end;
end;


function TDictionaryHelper<K, V>.ShuffleKeys: TArray<K>;
var
  LKeysList: TListHelper<K>;
begin
  LKeysList := TListHelper<K>.Create(Self.Keys.ToArray);
  try
    LKeysList.Shuffle;
    Result := LKeysList.ToArray;
  finally
    LKeysList.Free;
  end;
end;

function TDictionaryHelper<K, V>.Skip(
  const ACount: Integer): TDictionaryHelper<K, V>;
var
  LPair: TPair<K, V>;
  LCount: Integer;
begin
  Result := TDictionaryHelper<K, V>.Create;
  LCount := 0;

  for LPair in Self do
  begin
    if LCount >= ACount then
      Result.Add(LPair.Key, LPair.Value)
    else
      Inc(LCount);
  end;
end;

function TDictionaryHelper<K, V>.SkipWhile(
  const APredicate: TFunc<K, Boolean>): TDictionary<K, V>;
var
  LPair: TPair<K, V>;
  LFound: Boolean;
begin
  Result := TDictionary<K, V>.Create;
  LFound := False;

  for LPair in Self do
  begin
    if not LFound and not APredicate(LPair.Key) then
      LFound := True;

    if LFound then
      Result.Add(LPair.Key, LPair.Value);
  end;
end;

function TDictionaryHelper<K, V>.Slice(AStartIndex,
  AEndIndex: Integer): TDictionaryHelper<K, V>;
var
  LPair: TPair<K, V>;
  LIndex: Integer;
begin
  Result := TDictionaryHelper<K, V>.Create;
  LIndex := 0;

  for LPair in Self do
  begin
    if (LIndex >= AStartIndex) and (LIndex <= AEndIndex) then
      Result.Add(LPair.Key, LPair.Value);

    if LIndex > AEndIndex then
      Break;

    Inc(LIndex);
  end;
end;

function TDictionaryHelper<K, V>.SortedKeys: TArray<K>;
var
  LList: TList<K>;
begin
  LList := TList<K>.Create(Self.Keys);
  try
    LList.Sort;
    Result := LList.ToArray;
  finally
    LList.Free;
  end;
end;

function TDictionaryHelper<K, V>.Take(
  const ACount: Integer): TDictionaryHelper<K, V>;
var
  LPair: TPair<K, V>;
  LCount: Integer;
begin
  Result := TDictionaryHelper<K, V>.Create;
  LCount := 0;
  for LPair in Self do
  begin
    if LCount >= ACount then
      Break;

    Result.Add(LPair.Key, LPair.Value);
    Inc(LCount);
  end;
end;

function TDictionaryHelper<K, V>.TakeWhile(
  const APredicate: TFunc<K, Boolean>): TDictionary<K, V>;
var
  LPair: TPair<K, V>;
begin
  Result := TDictionary<K, V>.Create;

  for LPair in Self do
  begin
    if APredicate(LPair.Key) then
      Result.Add(LPair.Key, LPair.Value)
    else
      break;
  end;
end;

function TDictionaryHelper<K, V>.ToString: string;
var
  LPair: TPair<K, V>;
  ResultBuilder: TStringBuilder;
  LKey: TValue;
  LValue: TValue;
begin
  ResultBuilder := TStringBuilder.Create;
  try
    for LPair in Self do
    begin
      LKey := TValue.From<K>(LPair.Key);
      LValue := TValue.From<V>(LPair.Value);
      if LKey.IsObject then
        ResultBuilder.AppendLine(Format('%s: %s', [LKey.AsObject.ToString, LValue.ToString]))
      else
        ResultBuilder.AppendLine(Format('%s: %s', [LKey.ToString, LValue.ToString]));
    end;
    Result := ResultBuilder.ToString;
  finally
    ResultBuilder.Free;
  end;
end;

function TDictionaryHelper<K, V>._ComparePairs(const Left, Right: TPair<K, V>): Integer;
begin
  Result := TComparer<K>.Default.Compare(Left.Key, Right.Key);
end;

procedure TDictionaryHelper<K, V>.Unique;
var
  LUniqueValues: TDictionary<V, boolean>;
  LPair: TPair<K, V>;
begin
  LUniqueValues := TDictionary<V, boolean>.Create;
  try
    for LPair in Self do
    begin
      if not LUniqueValues.ContainsKey(LPair.Value) then
        LUniqueValues.AddOrSetValue(LPair.Value, true)
      else
        Self.Remove(LPair.Key);
    end;
  finally
    LUniqueValues.Free;
  end;
end;


function TDictionaryHelper<K, V>.Zip<T1, T2, TResult>(
  const AList1: TDictionaryHelper<K, T1>;
  const AList2: TDictionaryHelper<K, T2>;
  const AFunc: TFunc<T1, T2, TResult>): TDictionaryHelper<K, TResult>;
var
  LKey: K;
  LValue1, LValue2: TValue;
begin
  Result := TDictionaryHelper<K, TResult>.Create;

  for LKey in AList1.Keys do
  begin
    if AList2.TryGetValue(LKey, LValue2) then
    begin
      LValue1 := TValue.From<T1>(AList1[LKey]);
      Result.Add(LKey, AFunc(LValue1.AsType<T1>, LValue2.AsType<T2>));
    end;
  end;
end;

end.
