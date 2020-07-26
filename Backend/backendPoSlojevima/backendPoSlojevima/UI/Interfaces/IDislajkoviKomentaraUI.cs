using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.UI.Interfaces
{
    public interface IDislajkoviKomentaraUI
    {
        List<DislajkoviKomentari> getAllDislajkovi();
        void saveDislajk(DislajkoviKomentari data);
        void deleteDislajkoveKomentaraByIdKomentara(long idKomentara);
        void deleteDislajkoveKomentaraByIdKorisnika(long idKorisnika);
        List<DislajkoviKomentari> getDisajkoveKomentaraByIdKomentara(long idKometara);
        long getBrojDislajkovaByIdKomentara(long idKomentara);
        List<DislajkoviKomentari> getDislajkoveKomentaraByKorisnikId(PrihvatanjeIdKorisnika data);
        int getDislajkKomentaraByIdKorisnika(long idKorisnika, long idKomentara); 
        List<Korisnik> getKorisnikeKojiDislajkujuByIdKomentara(long idKomentara);
    }
}
