function out=checkOneToOne(trans, val)
out=round(trans.fromRot(round(trans.toRot(val))))-val;
end