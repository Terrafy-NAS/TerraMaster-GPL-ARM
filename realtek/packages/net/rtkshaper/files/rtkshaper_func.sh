
MODULES='sch_ingress sch_sfq sch_htb sch_fq_codel cls_u32 cls_fw em_u32 act_police act_connmark act_mirred'
DBG_FILE=/tmp/rtkshaper.log
DBG=true

_tc()
{
	if [ "$DBG" = "true" ]; then
		echo "tc $*" >> $DBG_FILE
		tc $* >> $DBG_FILE 2>&1
	else
		tc $*
	fi
}

_ipt()
{
	if [ "$DBG" = "true" ]; then
		echo "iptables $*" >> $DBG_FILE
		iptables $* >> $DBG_FILE 2>&1
	else
		iptables $*
	fi
}

_ip()
{
	if [ "$DBG" = "true" ]; then
		echo "ip $*" >> $DBG_FILE
		ip $* >> $DBG_FILE 2>&1
	else
		ip $*
	fi
}

[ -x /usr/sbin/modprobe ] && {
        insmod="modprobe"
	rmmod="rmmod"
} || {
        insmod="insmod"
        rmmod="rmmod"
}

add_insmod() {
        eval "export isset=\${insmod_$1}"
        case "$isset" in
                1) ;;
                *) {
                        [ "$2" ] && $rmmod $1 >&- 2>&-
                        $insmod $* >&- 2>&-
                };;
        esac
}

add_modules()
{
	for i in $MODULES ; do
        	add_insmod $i
	done
}

remove_modules()
{
	for i in $MODULES ; do
		$rmmod $i
	done
}

ifb_name() {
    local CUR_IF=$1
    local MAX_IF_NAME_LENGTH=15
    local IFB_PREFIX="ifb4"
    local NEW_IFB="${IFB_PREFIX}${CUR_IF}"
    local IFB_NAME_LENGTH=${#NEW_IFB}
    # IFB names can only be 15 chararcters, so we chop of excessive characters
    # at the start of the interface name
    if [ ${IFB_NAME_LENGTH} -gt ${MAX_IF_NAME_LENGTH} ];
    then
        local OVERLIMIT=$(( ${#NEW_IFB} - ${MAX_IF_NAME_LENGTH} ))
        NEW_IFB=${IFB_PREFIX}${CUR_IF:${OVERLIMIT}:$(( ${MAX_IF_NAME_LENGTH} - ${#IFB_PREFIX} ))}
    fi
    echo ${NEW_IFB}
}

# for low bandwidth links fq_codels default target of 5ms does not work too well
# so increase target for slow links (note below roughly 2500kbps a single packet will \
# take more than 5 ms to be tansfered over the wire)
adapt_target_to_slow_link() {
	CUR_LINK_KBPS=$1
	CUR_EXTENDED_TARGET_US=
	MAX_PAKET_DELAY_IN_US_AT_1KBPS=$(( 1000 * 1000 *1540 * 8 / 1000 ))
	CUR_EXTENDED_TARGET_US=$(( ${MAX_PAKET_DELAY_IN_US_AT_1KBPS} / ${CUR_LINK_KBPS} ))    # note this truncates the decimals
	# do not change anything for fast links
	[ "$CUR_EXTENDED_TARGET_US" -lt 5000 ] && CUR_EXTENDED_TARGET_US=5000
	echo "${CUR_EXTENDED_TARGET_US}"
}

# codel looks at a whole interval to figure out wether observed latency stayed below target
# if target >= interval that will not work well, so increase interval by the same amonut that target got increased
adapt_interval_to_slow_link() {
	CUR_TARGET_US=$1
	CUR_EXTENDED_INTERVAL_US=$(( (100 - 5) * 1000 + ${CUR_TARGET_US} ))
	echo "interval ${CUR_EXTENDED_INTERVAL_US}us"
}

# set the target parameter, also try to only take well formed inputs
# Note, the link bandwidth in the current direction (ingress or egress)
# is required to adjust the target for slow links
get_target() {
	local CUR_LINK_KBPS=$1

	TMP_TARGET_US=$( adapt_target_to_slow_link $CUR_LINK_KBPS )
	TMP_INTERVAL_STRING=$( adapt_interval_to_slow_link $TMP_TARGET_US )
	CUR_TARGET_STRING="target ${TMP_TARGET_US}us ${TMP_INTERVAL_STRING}"

	echo "$CUR_TARGET_STRING"
}

reverse()
{
        local line
	if IFS= read -r line
	then
		reverse
		printf '%s\n' "$line"
	fi
}

#TC=_tc
#IPT=_ipt
#IP=_ip

if [ "$DBG" = "true" ]; then
	rm -f $DBG_FILE
fi
