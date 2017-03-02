ldapid() {
	# Config
	local LDAPID_CONFIG="${LDAPID_CONFIG:-~/.dotfiles/local/ldapid}"
	if [ ! -f "${LDAPID_CONFIG}" ]; then
		echo "${LDAPID_CONFIG} not found"
		return 1
	fi

	# Variables
	local hostid hostpart
	REPORTTIME=10000

	handleHost() {
		local line id value i hostList hostNumbers
		declare -A hostList
		declare -A hostNumbers
		if [ "${#}" -gt 0 -a "${1}" != '?' ]; then
			hostid="${1}"
		fi
		# Parse hostlist
		i=1
		while IFS='' read line; do
			# Comments and empty lines
			[[ "$(echo "${line}" | xargs)" =~ ^\# ]] || [ "$(echo "${line}" | xargs)" = '' ] && continue
			# Skip identities
			[[ "${line}" =~ ^\	 ]] && continue
			# Split ID and value
			echo "${line}" | { read id value }
			hostNumbers[${i}]="${id}"
			hostList[${id}]="${value}"
			((i++))
		done < "${LDAPID_CONFIG}"
		# Parse request
		while :; do
			if [ "${hostid}" != '' ]; then
				if [[ "${hostid}" =~ ^[0-9]+$ ]]; then
					if [ "${hostid}" = 0 ]; then
						hostid=''
						hostpart=''
						break
					fi
					if (( ${+hostNumbers[${hostid}]} )); then
						hostpart="${hostList[${hostNumbers[${hostid}]}]}"
						hostid="${hostNumbers[${hostid}]}"
						break
					else
						echo "\"${hostid}\" not found"
					fi
				else
					if (( ${+hostList[${hostid}]} )); then
						hostpart="${hostList[${hostid}]}"
						break
					else
						echo "\"${hostid}\" not found"
					fi
				fi
			fi
			# Menu
			echo
			echo "0: None"
			i=1
			for id in "${hostNumbers[@]}"; do
				echo "${i}: ${id}"
				((i++))
			done
			read "hostid?Your host choice? "
		done
	}

	handleIdentity() {
		local i line identityId currentHost junk id value
		declare -A identityNumbers
		declare -A identityList
		if [ "${#}" -gt 1 -a "${2}" != '?' ]; then
			identityId="${2}"
		fi
		# Parse identites
		i=1
		while IFS='' read line; do
			# Comments and empty lines
			[[ "$(echo "${line}" | xargs)" =~ ^\# ]] || [ "$(echo "${line}" | xargs)" = '' ] && continue
			# Hosts
			if ! [[ "${line}" =~ ^\	 ]]; then
				echo "${line}" | { read currentHost junk }
				continue
			fi
			[ "${currentHost}" != "${hostid}" ] && continue
			echo "${line}" | { read id value }
			identityNumbers[${i}]="${id}"
			identityList[${id}]="${value}"
			((i++))
		done < "${LDAPID_CONFIG}"
		# Parse request
		while :; do
			if [ "${identityId}" != '' ]; then
				if [[ "${identityId}" =~ ^[0-9]+$ ]]; then
					if [ "${identityId}" = 0 ]; then
						identity=''
						break
					fi
					if (( ${+identityNumbers[${identityId}]} )); then
						identity="${identityList[${identityNumbers[${identityId}]}]}"
						break
					else
						echo "\"${identityId}\" not found"
					fi
				else
					if (( ${+identityList[${identityId}]} )); then
						identity="${identityList[${identityId}]}"
						break
					else
						echo "\"${identityId}\" not found"
					fi
				fi
			fi
			# Menu
			echo
			echo "0: None"
			i=1
			for id in "${identityNumbers[@]}"; do
				echo "${i}: ${id}"
				((i++))
			done
			read "identityId?Your identity choice? "
		done
	}

	handleHost $@
	if [ ! -z "${hostid}" ]; then
		handleIdentity $@
	fi
	export LDAPID="${hostpart} ${identity}"
}

for cmd in ldapadd ldapcompare ldapdelete ldapexop ldapmodify ldapmodrdn ldappasswd ldapsearch ldapurl ldapwhoami; do
	if hash "${cmd}"; then
		${cmd}() {
			command "${cmd}" ${LDAPID} $@
		}
	fi
done
