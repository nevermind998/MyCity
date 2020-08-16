using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.BL.Interfaces
{
    public interface IDislajkoviKomentaraBL
    {
        List<DislajkoviKomentari> getAllDislajkovi();
        void saveDislajk(DislajkoviKomentari data);
        void deleteDislajkoveKomentaraByIdKomentara(long idKomentara);
        void deleteDislajkoveKomentaraByIdKorisnika(long idKorisnika);
        List<DislajkoviKomentari> getDisajkoveKomentaraByIdKomentara(long idKometara);
        long getBrojDislajkovaByIdKomentara(long idKomentara);
        List<DislajkoviKomentari> getDislajkoveKomentaraByKorisnikId(long data);
        List<Korisnik> getKorisnikeKojiDislajkujuByIdKomentara(long idKomentara);
        int getDislajkKomentaraByIdKorisnika(long idKorisnika, long idKomentara);
    }
}
