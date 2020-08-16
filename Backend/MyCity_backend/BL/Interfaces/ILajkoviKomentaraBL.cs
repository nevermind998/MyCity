using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.BL.Interfaces
{
    public interface ILajkoviKomentaraBL
    {
        List<LajkoviKomentara> getAllLajkovi();
        void saveLajk(LajkoviKomentara data);
        void deleteLajkoveKomentaraByIdKomentara(long idKomentara);
        void deleteLajkoveKomentaraByIdKorisnika(long idKorisnika);
        List<LajkoviKomentara> getLajkoveKomentaraByIdKomentara(long idKometara);
        long getBrojLajkovaByIdKomentara(long idKomentara);
        List<LajkoviKomentara> getLajkovekomenatarByKorisnikId(long idKorisnika);
        List<Korisnik> getKorisnikeKojiLajkujuByIdKomentara(long  idKomentara);
        int getLajkKomentaraByIdKorisnika(long idKorisnika, long idKomentara);
    }
}
