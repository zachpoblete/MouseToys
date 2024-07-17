Object.prototype.defineProp('refProp', {call: ObjProto_RefProp})
/**
 * Taken from Lexikos from:
 * https://www.autohotkey.com/boards/viewtopic.php?p=394816#p394816
 */
ObjProto_RefProp(this, name) {
    desc := this.getOwnPropDesc(name)
    if desc.hasProp('value') {
        this.defineProp(name, makeRef(desc))
    } else if not desc.get.hasProp('ref') {
        throw Error('Invalid property for ref', -1, name)
    }

    return desc.get.ref

    makeRef(desc) {
        v := desc.deleteProp('value')
        desc.get := (this)        => v
        desc.set := (this, value) => v := value
        desc.get.ref := &v
        return desc
    }
}
