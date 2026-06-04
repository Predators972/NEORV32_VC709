Update: 
1. Remove the use of real type and ceilling function to let it campatible with older version synthesizer.
2. Type of Leaky_rate and recharge_rate changed to SFIXED(was NATURAL) for finer control on memory decay.
3. New Encoder vertor added for generating different spike train on different encoder even with same input (achieved by xor the output with a random number, 
   so NOT fully generic, mask random number need to be added/removed manully to match the number of encoder).
4. Ports for manully configure weights are temporary removed.
5. Add a option to randomlize weights between 0 and 1 (was only support -1 to 1), changed by manully comment/uncomment code of weight holder (see comment in line 154 of the weight holder).